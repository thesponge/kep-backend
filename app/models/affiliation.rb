class Affiliation < ActiveRecord::Base
  has_and_belongs_to_many :accounts

  validates :affiliation, :link, presence: true
  validates :affiliation, :link, uniqueness: true

end
