class Skill < ActiveRecord::Base

  update_index('kep#account') { accounts }
  update_index('kep#assignment') { assignment }

  has_many :skill_maps, :dependent => :destroy
  has_many :accounts, :through => :skill_maps, :source => :skill_map, :source_type => "Account"
  has_many :assignments, :through => :skill_maps, :source => :skill_map, :source_type => "Assignment"

end
