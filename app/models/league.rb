 # == Schema Information
#
# Table name: leagues
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  commissioner_id :integer
#  show_id         :integer
#  public_access   :boolean          default(TRUE)
#  draft_type      :string(255)
#  scoring_system  :integer
#  created_at      :datetime
#  updated_at      :datetime
#  league_key      :string(255)
#  league_password :string(255)
#

class League < ActiveRecord::Base
	belongs_to :show
	has_and_belongs_to_many :users
	has_many :rosters, through: :users
	has_many :rounds
	# has_one :scoring

	before_save :set_up_league

	validates :name, :presence => true, :length => { :minimum => 3 }, :on => :create
	validates :commissioner_id, :presence => true

	private
	def gen_league_key
		self.league_key = SecureRandom.hex(5)
	end

	def gen_league_password
		self.league_password = SecureRandom.hex(5)
	end

	def set_up_league
		if public_access == false # if the league is private
			gen_league_key
			gen_league_password
		end
	end
	

end
