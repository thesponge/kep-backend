class KepIndex < Chewy::Index

  settings analysis: {
    filter: {
      my_metaphone: {
        type: "phonetic",
        encoder: "metaphone",
        replace: false
      },
      my_ascii_folding: {
        type: "asciifolding",
        preserve_original: true
      },
      #Find out why this filter doesn't do it's job
      my_email: {
        type: "pattern_capture",
        preserve_original: true,
        patterns: ["([^@]+)", "(\\p{L}+)", "(\\d+)", "@(.+)", "([^-@]+)" ]
      }
    },
    analyzer: {
      title: {
        analyzer: 'simple',
        tokenizer: 'standard',
        filter: ['lowercase', 'asciifolding']
      },
      description: {
        analyzer: 'simple',
        tokenizer: 'standard',
        filter: ['lowercase', 'asciifolding']
      },
      bio: {
        analyzer: 'simple',
        tokenizer: 'standard',
        filter: ['lowercase', 'asciifolding']
      },
      owner_name: {
        tokenizer: "standard",
        filter: ["standard", "lowercase", "my_metaphone"]
      },
      owner_email: {
        tokenizer: "uax_url_email",
        filter: ["my_email", "lowercase", "unique"]
      },
      locations: {
        tokenizer: "keyword",
        filter: ["lowercase", "my_ascii_folding"]
      }
    }
  }

  define_type Account.includes(:user,:locations, :languages, :skills, :intentions, :affiliations) do
    field :id, type: "integer"
    field :owner_id, type: "integer", value: -> { user_id }
    field :owner_email, type: "string", value: -> { user.email}
    field :owner_name, type: "string", value: -> { display_name}
    field :bio
    field :available, type: "boolean"
    field :affiliations do
      field :id, type: 'integer'
      field :affiliation, :link
    end
    field :locations do # the same block syntax for multi_field, if `:type` is specified
      field :id, type: 'integer'
      field :country, :state, :city
      field :location_type, type: 'string', index: 'not_analyzed'
    end
    field :languages do
      field :id, type: 'integer'
      field :iso, :common, index: 'not_analyzed'
    end
    field :skills do
      field :id, type: 'integer'
      field :category, :name, index: 'not_analyzed'
    end
    field :intentions do
      field :id, type: 'integer'
      field :intention, index: 'not_analyzed'
    end
  end


  define_type Assignment.includes(:user, :locations, :languages, :skills, :assignment_rewards, :assignment_bids) do
    field :id, type: "integer"
    field :title, :description, :state
    field :progress_percent, type: 'integer'
    field :start_date, type: 'date'
    field :end_date, type: 'date'
    field :created_at, type: 'date'
    field :updated_at, type: 'date'
    field :published_at, type: 'date'
    field :owner_id, type: 'integer', value: ->{ user_id }
    field :owner_name, value: ->{ user.account.display_name }
    field :owner_email, type: 'string', value: ->{ user.email }
    field :locations do # the same block syntax for multi_field, if `:type` is specified
      field :id, type: 'integer'
      field :country, :state, :city
      field :location_type, type: 'string', index: 'not_analyzed'
    end
    field :languages do
      field :id, type: 'integer'
      field :iso, :common, index: 'not_analyzed'
    end
    field :skills do
      field :id, type: 'integer'
      field :category, :name, index: 'not_analyzed'
    end
    field :assignment_rewards do
      field :id, type: 'integer'
      field :reward,  index: 'not_analyzed'
    end
    field :assignment_bids do
      field :id, type: 'integer'
      field :user_id, type: 'integer'
      field :chosen, type: 'boolean'
      field :created_at, type: 'date'
      field :updated_at, type: 'date'
    end
  end

  define_type Resource.includes(:user, :intentions) do
    field :id, type: "integer"
    field :title, :description, :state
    field :created_at, type: 'date'
    field :updated_at, type: 'date'
    field :published_at, type: 'date'
    field :owner_id, type: 'integer', value: ->{ user_id }
    field :owner_name, value: ->{ user.account.display_name }
    field :owner_email,type: 'string', value: ->{ user.email }
    field :intentions do
      field :id, type: 'integer'
      field :intention, index: 'not_analyzed'
    end
  end

end
