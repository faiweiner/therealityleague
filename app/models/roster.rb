# == Schema Information
#
# Table name: rosters
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  league_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Roster < ActiveRecord::Base
	belongs_to :user
	belongs_to :league
	has_and_belongs_to_many :contestants, inverse_of: :rosters
	has_many :rounds
	
	validates :user_id, :presence => true
	validates :league_id, :presence => true

	def calculate_total_roster_points			# method for FANTASY only; takes a collection of contestants within one roster
		contestants = self.contestants
		roster_total_score = 0
		contestants.each do |contestant|
			roster_total_score += contestant.calculate_total_points
		end
		return roster_total_score
	end

	def calculate_total_rounds_points 		# method for BRACKET only; takes a collection of rounds within one roster
		rounds = self.rounds
		roster_total_rounds_score = 0
		rounds.each do |round|
			roster_total_rounds_score += round.calculate_round_points
		end
		return roster_total_rounds_score
	end
end
