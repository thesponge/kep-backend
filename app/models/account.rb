class Account < ActiveRecord::Base
  include PublicActivity::Model

  update_index('kep#account') { self }

  tracked only: [:notify_coleagues]

  belongs_to :user
  has_and_belongs_to_many :affiliations, after_add: :notify_coleagues

  has_many :intention_maps, :as => :intention_map
  has_many :intentions, :through => :intention_maps

  has_many :location_maps, :as => :location_map
  has_many :locations, :through => :location_maps

  has_many :language_maps, :as => :language_map
  has_many :languages, :through => :language_maps

  has_many :skill_maps, :as => :skill_map
  has_many :skills, :through => :skill_maps

  has_many :score_account_assignments, inverse_of: :account

  validates_presence_of :user

  def display_name
    read_attribute(:display_name) || self.user.read_attribute(:email)[/[^@]+/]
  end

  private

  def notify_coleagues(affiliation)
    size = affiliation.accounts.size
    affiliation.accounts.each_with_index.reject{|a,i| i == size - 1}.map{|a,i| a}.each do |acc|
      acc.create_activity action: 'new_coleague', owner: affiliation.accounts.last.user,
        recipient: acc.user, parameters: {display_name: affiliation.accounts.last.display_name}
    end
  end

end
