module InitializeSearch
  attr_accessor :properties

  def has_properties *args
    @properties = args
    instance_eval { attr_accessor *args }
  end

  def self.included base
    base.extend self
  end

  def initialize args
    args.each {|k,v|
      instance_variable_set "@#{k}", v if self.class.properties.member?(k)
    } if args.is_a? Hash
  end

  def attribute?(attr)
    instance_variable_get "@#{attr}"
  end

  def get_attribute_field attr, field
    self.public_send(attr) ? self.public_send(attr)[field] : nil
  end


  # Query for inexact strings (ex: title, description, bio)
  def query_string attr
    qs  = self.get_attribute_field attr, :value
    qs_rule = self.get_attribute_field attr, :rule
    if qs && (qs_rule == "fuzzy")
      index.query(match: {attr=> {query: qs, fuzziness:2, prefix_length:1}})
    elsif qs
      index.query(query_string: {fields: [attr], query: qs})
    else
       nil
    end
  end

  # Query fields of DateTime (ex :start_date, :end_date, :created_at, :updated_at, :published_at)
  def query_date attr
    query_by_range attr, Time.current, Time.current
  end


  # Query for associations (ex :locations, :languages, :skills, :assignment_bids, :assignment_rewards)
  def query_association attr
    # Query value: can be an integer (id), a string (category/name),an array of integers or one of strings
    qv = self.get_attribute_field attr, :value
    # Stating wich field should be searched for the query value
    qf = self.get_attribute_field attr, :field
    if qv && qf
      index.filter{public_send(attr).public_send(qf, (:&))== qv}
    else
      nil
    end
  end

  # Query for boolean values (ex: available)
  def query_bool attr
    qv = self.get_attribute_field attr, :value
    if qv
      index.filter{public_send(attr, (:|)) == qv}
    else
      nil
    end
  end

  #Query by id (ex: owner_id)
  def query_id attr
    qid = self.get_attribute_field attr, :value
    if qid
      index.filter{public_send(attr, (:|)) == qid}
    else
      nil
    end
  end

  # Query by range of numbers (ex: progress_percent)
  def query_number attr
    query_by_range attr
  end

  # Query for exact terms (ex: owner_email, state)
  def query_term attr
    qv = self.get_attribute_field attr, :value
    if qv
      index.filter{ public_send(attr, (:&)) == qv }
    else
      nil
    end
  end

  # Here type can be all the above i.e. string, date, associations, id, number, term
  def query_collection type, collection
    queries= []
    collection.each do |attr|
      queries << self.send("query_#{type.to_s}",attr.to_sym)
    end
    queries.compact
    # .compact.reduce(:merge)
  end

  def query_by_range attr, max = 100, min = 0
    qv = self.get_attribute_field attr, :value
    range_start = qv ? qv[:range_start] : nil
    range_end = qv ? qv[:range_end] : nil
    if range_start && range_end
      result = index.filter{ (public_send(attr) >= range_start) & (public_send(attr) <= range_end) }
    elsif range_start
      result = index.filter{ (public_send(attr) >= range_start) & (public_send(attr) <= max) }
    elsif range_end
      result = index.filter{ (public_send(attr) >= min) & (public_send(attr) <= range_end) }
    else
      nil
    end
  end

end
