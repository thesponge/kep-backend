class SkillMap < ActiveRecord::Base

  update_index('kep#account') { skill_map if skill_map_type == 'Account' }
  update_index('kep#assignment') { skill_map if skill_map_type == 'Assignment' }

  belongs_to :skill_map, :polymorphic => true
  belongs_to :skill
end
