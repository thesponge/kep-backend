class AutomaticMatches
  include Wisper::Publisher

  def generate(a,a_params)
    if a.skills.size || a.languages.size || a.locations.size > 0
      if method("match_#{a.class.to_s.downcase}").call(a,a_params)
        broadcast(:matches_generated, a)
      else
        broadcast(:matches_failed, a.errors)
      end
    else
      broadcast(:matches_unavailable)
    end
  end

  def update(a, a_params)
    if a_params.include?("skill_ids") || a_params.include?("language_ids") || a_params.include?("location_ids")
      ScoreAccountAssignment.where("#{a.class.to_s.downcase}_id": a.id).destroy_all
      generate(a,a_params)
    end
  end


  private

  def match_account(account,account_params)
    ( Assignment.includes(:skills).where.not(skills: { id: nil }) |
    Assignment.includes(:languages).where.not(languages: { id: nil }) |
    Assignment.includes(:locations).where.not(locations: {id: nil}) ).each do |assign|
      if assign.user_id != account.id
        total_score = total_score(account,assign)
        if total_score > 10.00
          automatch = ScoreAccountAssignment.new(assignment_id: assign.id, account_id: account.id)
          automatch.score_categories = score_categories(account,assign).to_json
          automatch.total_score = total_score
          automatch.save
        end
      end
    end
  end

  #Calculates score between compatible accounts and an assignment and puts them in
  # the db
  def match_assignment(assign,assign_params)
    ( Account.includes(:skills).where.not(skills: { id: nil }) |
    Account.includes(:languages).where.not(languages: { id: nil }) |
    Account.includes(:locations).where.not(locations: {id: nil}) ).each do |acc|
      if acc.id != assign.user_id
        total_score = total_score(acc,assign)
        if total_score > 10.00
          automatch = ScoreAccountAssignment.new(assignment_id: assign.id, account_id: acc.id)
          automatch.score_categories = score_categories(acc,assign).to_json
          automatch.total_score = total_score
          automatch.save
        end
      end
    end
  end


  # Makes a hash with the individual scores for skills & languages & locations
  def score_categories(account,assign)
    components = ["skill","language","location" ]
    score_categories = {}
    for c in components do
      score_categories["#{c}s"] = 0.00
    end

    for c in components do
      if !(method("total_score_#{c}").call(account,assign)).nan?
        if c == "skill"
          score_categories["#{c}s"] = {total_skills: total_score_skill(account,assign),
                                        skill_categories: score_skills_assign(account,assign) }
        else
          score_categories["#{c}s"] = method("total_score_#{c}").call(account,assign)
        end
      end
    end

    return score_categories
  end

  #Calculates the total compatibility score between an account and an assignment
  # based on all 3 common fields; returns a decimal which is the percent of
  # compatibility
  def total_score(account,assign)
    total_sum = 0.00
    categories = score_categories(account,assign)
    non_null = 0

    p categories
    categories.each do |k,v|
      k == "skills" && v != 0 ? total_sum += v[:total_skills] : total_sum += v
      get_assoc(assign,k).size > 0 ? non_null +=1 : non_null = non_null
    end
    return total_sum/non_null
  end

  def get_assoc(model,assoc_name)
    return model.method("#{assoc_name}").call()
  end

  #Calculatess the total score for locations/languages between an account and
  # an assignment; returns a decimal which is the percent
  def total_score_location(account,assign)
    common = (assign.locations & account.locations).size
    total = assign.locations.size
    return (common * 100.00) / total
  end

  #Calculatess the total score for languages between an account and
  # an assignment; returns a decimal which is the percent
  def total_score_language(account,assign)
    common = (assign.languages & account.languages).size
    total = assign.languages.size
    return (common * 100.00) /total
  end


  #Calculatess the total score for skills between an account and
  # an assignment; returns a decimal which is the percent
  def total_score_skill(account,assign)
    score_categories = score_skills_assign(account,assign)
    sum = 0.00
    categories = (assign.skills.map{|h| h.category}).uniq

    score_categories.each do |k,v|
      sum += v
    end

    total = sum / categories.size
  end

  # Calculates the compatibility_score/skill_category between an assignments skills
  #  and an accounts skills; returns a hash containing: {"name_of_category": "coresponding_score" }
  def score_skills_assign(account,assign)
    assign_skills = assign.skills
    account_skills= account.skills
    common_skills= assign_skills & account_skills
    score_skills = {}

    if common_skills == []
      total_score = 0.00
    else
      count_assign = count_categories(assign_skills)
      count_common = count_categories(common_skills)
      score_skills = score_category(count_assign,count_common)
    end

    return score_skills
  end

  #Calculates the score/skill_category based on formula:
  # nr_of_common_skills/nr_of_skills_in_obj
  #Return a hash containing: {"category" : "coresponding_score"}
  def score_category(object_hash,common_hash)
    scores  = {}
    object_hash.each do |k,v|
      scores["#{k}"] = 0.00
    end

    common_hash.each do |k,v|
      scores["#{k}"] = ((v * 100.0) / object_hash["#{k}"]).round(2)
    end
    return scores
  end

  #Counts how many skills/category an array of skills contains
  #Returns a hash containing: {"category" : "number_of_skills_in_that_category"}
  def count_categories(arr)
    count_hash = {}
    arr.each do |s|
      !(count_hash["#{s.category}"]) ? count_hash["#{s.category}"] = 1 : count_hash["#{s.category}"] += 1
    end
    return count_hash
  end
end
