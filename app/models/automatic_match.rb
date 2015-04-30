class AutomaticMatch < ActiveRecord::Base
include Matchable

  validate :different
  validates :table_name_1, format: { with: /\Aaccount|assignment\z/,
   message: "You can match only a user with an assignment" }, presence: true

  validates :table_name_2, format: { with: /\Aaccount|assignment\z/,
    message: "You can match only a user with an assignment" }, presence: true


  def different
    if table_name_1 == table_name_2
      errors.add(:table_name_1, "You can't match 2 thing of same type")
      # errors.add(:table_name_2)
    end
  end

end
