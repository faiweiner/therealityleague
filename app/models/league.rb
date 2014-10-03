# == Schema Information
#
# Table name: leagues
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  commissioner_id :integer
#  season_id       :integer
#  public_access   :boolean          default(TRUE)
#  type            :string(255)
#  draft_deadline  :datetime
#  scoring_system  :integer
#  league_key      :string(255)
#  league_password :string(255)
#  active          :boolean          default(TRUE)
#  created_at      :datetime
#  updated_at      :datetime
#

class League < ActiveRecord::Base

	belongs_to :season, inverse_of: :leagues
	has_and_belongs_to_many :users, inverse_of: :leagues
	before_destroy { users.clear }
	has_many :rosters, through: :users

# FIXME! Come bck to deal with dependencies please

	before_save :set_up_league

	validates :name, :presence => true, :length => { :minimum => 3 }, :on => :create
	validates :commissioner_id, :presence => true

	# sarch function
	def self.search_by_key(query)
		where("league_key LIKE ?", "%#{query}%").uniq.order("created_by DESC")
	end

	def self.search_by_season_name(query)
		includes(:season).joins(:season).where("season.name LIKE ?", "%#{query}%")
	end

	private

	def gen_league_key
		self.league_key = SecureRandom.hex(5)
	end

	def gen_league_password
		self.league_password = SecureRandom.hex(5)
	end

	def set_up_league
		if public_access == true # if the league is public
			gen_league_key
		else
			gen_league_key
			gen_league_password
		end
	end

end
