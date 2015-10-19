class LocationMap < ActiveRecord::Base

  update_index('kep#account') { location_map if location_map_type == 'Account' }
  update_index('kep#assignment') { location_map if location_map_type == 'Assignment' }


  belongs_to :location_map, :polymorphic => true
  belongs_to :location
end
