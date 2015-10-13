class Affiliation < ActiveRecord::Base

  update_index('kep#account') { accounts }

  has_and_belongs_to_many :accounts

  validates :affiliation, :link, presence: true
  validates :affiliation, :link, uniqueness: true

end
