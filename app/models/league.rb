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
#  participant_cap :integer
#  draft_limit     :integer
#  draft_deadline  :datetime
#  draft_order     :string(255)
#  scoring_system  :integer
#  league_key      :string(255)
#  league_password :string(255)
#  active          :boolean          default(TRUE)
#  created_at      :datetime
#  updated_at      :datetime
#  locked          :boolean          default(FALSE)
#  full            :boolean          default(FALSE)
#

class League < ActiveRecord::Base
	
	belongs_to :season, inverse_of: :leagues
	has_and_belongs_to_many :users, inverse_of: :leagues
	before_destroy { users.clear }
	has_many :rosters
	has_many :rounds
	has_and_belongs_to_many :schemes

	# FIXME! Come bck to deal with dependencies please
	before_save :set_up_league, :set_draft_limit
	after_initialize :update_full_field

	validates :name, :presence => true, :length => { :minimum => 3 }, :on => :create
	validates :commissioner_id, :presence => true
	validates :draft_deadline, :presence => true, :on => :create

	# sarch functions
	def self.search_by_key(query)
		joins(:season, :users).where(league_key: query).uniq.order("created_at DESC")
	end

	def self.search_by_season_name(query)
		includes(:season).joins(:season).where("season.name LIKE ?", "%#{query}%")
	end

	def self.search_by_show_name(query)
	end
	
	def self.select_type
		@type = [["Fantasy", "Fantasy"],["Elimination", "Elimination"]]		
	end
	
	def lock_league
		self.update!(locked: true)
	end

	def unlock_league
		self.update!(locked: false)
	end
	
	private

	def gen_league_key
		self.league_key = SecureRandom.hex(5)
	end

	def gen_league_password
		self.league_password = SecureRandom.hex(5)
	end

	def gen_draft_limit
		season = Season.find(self.season_id)
		self.draft_limit = (season.contestants.count / self.participant_cap).floor
	end

	def update_full_field
		if self.full == false
			self.update!(full: true) if self.participant_cap && self.participant_cap == self.users.count
		end
	end

	def set_up_league
		if public_access == true # if the league is public
			gen_league_key
		else
			gen_league_key
			gen_league_password
		end
	end	

	def set_draft_limit
		if participant_cap != nil
			gen_draft_limit
		end
	end
end
