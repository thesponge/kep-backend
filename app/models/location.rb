class Location < ActiveRecord::Base

  update_index('kep#account') { accounts }
  update_index('kep#assignment') { assignments }


  has_many :location_maps, :dependent => :destroy
  has_many :accounts, :through => :location_maps, :source => :location_map, :source_type => "Account"
  has_many :assignments, :through => :location_maps, :source => :location_map, :source_type => "Assignment"

  validates :country, :location_type, presence: true
  validates :location_type, :inclusion => %w(residence expertise)
end
