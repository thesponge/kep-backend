class Language < ActiveRecord::Base

  update_index('kep#account') { accounts }
  update_index('kep#assignment') { assignments }

  has_many :language_maps, :dependent => :destroy
  has_many :accounts, :through => :language_maps, :source => :language_map, :source_type => "Account"
  has_many :assignments, :through => :language_maps, :source => :language_map, :source_type => "Assignment"
end
