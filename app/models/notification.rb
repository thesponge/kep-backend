class Notification < ActiveRecord::Base
  belongs_to :user, inverse_of: :notifications
end
