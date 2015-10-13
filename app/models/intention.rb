class Intention < ActiveRecord::Base

  update_index('kep#account') { accounts }
  update_index('kep#resource') { resources }

  has_many :intention_maps, :dependent => :destroy
  has_many :accounts, :through => :intention_maps, :source => :intention_map, :source_type => "Account"
  has_many :resources, :through => :intention_maps, :source => :intention_map, :source_type => "Resource"

end
