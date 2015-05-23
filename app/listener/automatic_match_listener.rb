class AutomaticMatchListener

#! Implement assignment_errors

  def assignment_create(assignment)
    if assignment.skills.size != 0
      match_assignment(assignment)
    end
  end

  # def assignment_errors(assignment)
  #
  # end


  #Calculates score between compatible accounts and an account and puts them in
  # the db
  def match_assignment(assign)
    Account.includes(:skills).where.not(skills: { id: nil }).each do |acc|
      if acc.id != assign.user_id
        total_score = total_score_assign(acc,assign)
        if total_score > 10.00
          automatch = ScoreAccountAssignment.new(assignment_id: assign.id, account_id: acc.id)
          automatch.total_score = total_score
          automatch.score_categories = score_categories_assign(acc,assign).to_json
          automatch.save
        end
      end
    end
  end


  # Calculates the compatibility_score/category between an assignment and an account
  # Returns a hash containing: {"name_of_category": "coresponding_score" }
  def score_categories_assign(account,assign)
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

  #Calculatess the total compatibility score between an account and an assignment
  #Returns a decimal which is the percent of compatibility
  def total_score_assign(account,assign)
    score_categories = score_categories_assign(account,assign)
    sum = 0
    categories = (assign.skills.map{|h| h.category}).uniq

    score_categories.each do |k,v|
      sum += v
    end

    total = sum / categories.size
  end

  #Calculates the score/category based on formula: nr_of_common_skills/nr_of_skills_in_obj
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
