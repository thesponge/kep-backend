class Account < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :affiliations

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

end
