class AccountSearch
  include InitializeSearch

  has_properties  :id, :owner_id, :owner_email, :owner_name, :bio, :available,
                  :affiliations, :intentions, :locations, :languages, :skills

  def initialize args
    super
  end

  def index
    KepIndex::Account
  end

  def search
    [query_collection(:string, [:bio]),
     query_collection(:id, [:id, :owner_id]),
     query_collection(:association, [:intentions, :affiliations, :locations, :skills,
      :languages]), query_collection(:bool, [:available]),
     query_collection(:term, [:owner_email, :owner_name])].reduce(:concat).reduce(:merge)
  end

end
