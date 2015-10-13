class IntentionMap < ActiveRecord::Base

  update_index('kep#account') { intention_map if intention_map_type == 'Account' }
  update_index('kep#resource') { intention_map if intention_map_type == 'Resource' }

  belongs_to :intention_map, :polymorphic => true
  belongs_to :intention
end
