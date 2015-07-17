class User < ActiveRecord::Base
  has_one  :account, dependent: :destroy
  has_many :assignments, inverse_of: :user
  has_many :assignment_bids, inverse_of: :user
  has_many :resources, inverse_of: :user
  has_many :priorities, foreign_key: "chosen_id", inverse_of: :user
  has_many :notifications, inverse_of: :user
  has_many :ur_matches, class_name: "MatchUserResource", foreign_key: "matcher_id"
  has_many :ur_nominations, class_name: "MatchUserResource", foreign_key: "nominee_id"

  has_many :uu_matches, class_name: "MatchUserUser", foreign_key: "matcher_id"
  has_many :uu_nominations, class_name: "MatchUserUser", foreign_key: "nominee_id"
  has_many :uu_second_nominations, class_name: "MatchUserUser", foreign_key: "second_nominee_id"
  has_many :match_assignment_resources, foreign_key: "matcher_id", inverse_of: :user

  accepts_nested_attributes_for :account , allow_destroy: true
  before_create :build_account

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  before_save :ensure_authentication_token

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  private

    def generate_authentication_token
      loop do
        token = Devise.friendly_token
        break token unless User.where(authentication_token: token).first
      end
    end

end
