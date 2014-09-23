# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  email            :string(255)
#  username         :string(255)
#  password_digest  :string(255)
#  avatar           :string(255)
#  oauth_token      :string(255)
#  oauth_expires_at :datetime
#  created_at       :datetime
#  updated_at       :datetime
#  admin            :boolean          default(FALSE)
#

class User < ActiveRecord::Base

	EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	has_and_belongs_to_many :leagues, inverse_of: :users
	has_many :rosters
	has_many :contestants, through: :rosters
	has_many :seasons, through: :leagues
	has_many :rounds, through: :rosters

	# FIXME! Come bck to deal with dependencies please

	has_secure_password
	validates :email, presence: true, uniqueness: true, length: { :minimum => 6 }, on: :create
	validates_format_of :email, :with => EmailRegex
	validates :username, presence: true, uniqueness: true, length: { :minimum => 6 }, on: :create
	validates :password, length: { in: 6..20 }, confirmation: true
	validates :password_confirmation, presence: true, :on => :update, :unless => lambda{ |user| user.password.blank? }

	def roster_for_league(league)
		roster = self.rosters.where(:league_id => league.id).first
		roster || Roster.first
	end
end

