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

	def calculate_total_roster_points			# takes a collection of contestants within one roster
		contestants = self.contestants
		roster_total_score = 0
		contestants.each do |contestant|
			roster_total_score += contestant.calculate_total_points
		end
		return roster_total_score
	end

	def calculate_weekly_roster_points(round_id)
		contestants = self.contestants
		roster_weekly_score = 0
		contestants.each do |contestant|
			roster_weekly_score += contestant.calculate_points_per_episode(episode_id)
		end
		return roster_weekly_score
	end
end
