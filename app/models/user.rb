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
#  admin            :boolean          default(FALSE)
#  created_at       :datetime
#  updated_at       :datetime
#  last_logged_in   :datetime
#  oauth_provider   :string(255)
#  oauth_id         :text
#  timezone         :integer
#

class User < ActiveRecord::Base

	EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	has_and_belongs_to_many :leagues, inverse_of: :users
	has_many :rosters
	has_many :rounds
	has_many :contestants, through: :rosters
	has_many :seasons, through: :leagues
	has_many :messages

	# FIXME! Come bck to deal with dependencies please
	before_create :downcase_field

	has_secure_password
	validates :email, presence: true, 
										uniqueness: true, 
										length: { minimum: 6 }, 
										on: :create, 
										case_sensitive: false
	validates_format_of :email, with: EmailRegex
	validates :username, presence: true, 
										length: { minimum: 6 }, 
										on: :create, 
										case_sensitive: false
	validates :password, length: { in: 6..20 }, 
										confirmation: true
	validates :password_confirmation, 
										presence: true, 
										on: :update, 
										unless: lambda{ |user| user.password.blank? }
	validates :oauth_id, uniqueness: true

	#	def create_with_oauth(params)
	#		self.assign_attributes({
	#			oauth_provider: params[:user][:oauth_provider],
	#			oauth_id: params[:user][:id],
	#			username: params[:user][:username],
	#			email: params[:user][:email],
	#			timezone: params[:user][:timezone],
	#			password: "password",
	#			password_confirmation
	#		})
	# end

	def update_with_oauth(params)
		self.update_columns({
			oauth_provider: params[:user][:oauth_provider],
			oauth_id: params[:user][:oauth_id],
			avatar: params[:user][:avatar],
			email: params[:user][:email],
			timezone: params[:user][:timezone]
		})
	end
	def roster_for_league(league)
		roster = self.rosters.where(:league_id => league.id).first
		roster || Roster.first
	end

	def rounds_for_league(league)
		rounds = self.rounds.where(:league_id =>league.id)
	end

	def calculate_total_rounds_points(league)
		rounds = rounds_for_league(league)
		total_rounds_score = 0
		rounds.each do |round|
			total_rounds_score += round.calculate_round_points
		end
		return total_rounds_score
	end

	private

	def downcase_field
		self.email.downcase!
	end
	def gen_new_password
		self.password = SecureRandom.hex(5)
	end

end

