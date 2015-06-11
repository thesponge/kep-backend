class Assignment < ActiveRecord::Base
  include Filterable

  belongs_to :user, inverse_of: :assignments

  has_and_belongs_to_many :assignment_rewards
  has_and_belongs_to_many :assignment_priorities

  has_many :location_maps, :as => :location_map
  has_many :locations, :through => :location_maps,
                       :after_remove => proc { |a| a.touch },
                       :after_add => proc { |a| a.touch unless a.new_record? }

  has_many :language_maps, :as => :language_map
  has_many :languages, :through => :language_maps,
                       :after_remove => proc { |a| a.touch },
                       :after_add => proc { |a| a.touch unless a.new_record?}

  has_many :skill_maps, :as => :skill_map
  has_many :skills, :through => :skill_maps,
                    :after_remove => proc { |a| a.touch },
                    :after_add => proc { |a| a.touch unless a.new_record?  }

  has_many :score_account_assignments, inverse_of: :assignment
  has_many :assignment_bids, inverse_of: :assignment

  accepts_nested_attributes_for :assignment_priorities

  validates :title, presence: true, length: { in: 5..150 }
  validates :description, presence: true, length: { in: 50..3000}

  scope :title, -> (title) {where title: title}
  scope :travel, -> (travel) {where travel: travel}
  scope :driver_license, -> (driver_license) {where driver_license: driver_license}


end
