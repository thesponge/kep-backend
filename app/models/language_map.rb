class LanguageMap < ActiveRecord::Base

  update_index('kep#account') { language_map if language_map_type == 'Account' }
  update_index('kep#assignment') { language_map if language_map_type == 'Assignment' }

  belongs_to :language_map, :polymorphic => true
  belongs_to :language
end
