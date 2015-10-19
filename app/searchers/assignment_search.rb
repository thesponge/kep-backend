class AssignmentSearch
  include InitializeSearch

  has_properties :id, :title, :description, :state, :progress_percent, :start_date, :end_date,
                :created_at, :updated_at, :published_at, :owner_id, :owner_email, :owner_name,
                :locations, :languages, :skills, :assignment_bids, :assignment_rewards

  def initialize args
    super
  end

  def index
    KepIndex::Assignment
  end

  def search
    [query_collection(:string, [:title, :description]), query_collection(:id, [:id, :owner_id]),
     query_collection(:date, [:start_date, :end_date, :created_at, :updated_at, :published_at]),
     query_collection(:number, [:progress_percent]), query_collection(:association, [:locations,
      :languages, :skills, :assignment_bids, :assignment_rewards]),
     query_collection(:term, [:state, :owner_email, :owner_name])].reduce(:concat).reduce(:merge)
  end

end
