class ResourceSearch
  include InitializeSearch

  has_properties  :id, :title, :description, :state, :created_at, :updated_at,
                  :published_at, :owner_id, :owner_name, :owner_email, :intentions

  def initialize args
    super
  end

  def index
    KepIndex::Resource
  end

  def search
    [query_collection(:string, [:title, :description]),
     query_collection(:id, [:id, :owner_id]),
     query_collection(:date, [:created_at, :updated_at, :published_at]),
     query_collection(:association, [:intentions]),
     query_collection(:term, [:state, :owner_email, :owner_name])].reduce(:concat).reduce(:merge)
  end

end
