# == Schema Information
#
# Table name: rounds
#
#  id         :integer          not null, primary key
#  roster_id  :integer
#  episode_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Round < ActiveRecord::Base
	belongs_to :roster
	belongs_to :episode
	has_and_belongs_to_many :contestants, inverse_of: :rounds

	def calculate_round_points
		contestants = self.contestants
		round_id = self.id
		round_score = 0
		contestants.each do |contestant|
			round_score += contestant.calculate_points_per_round(round_id)
		end
		return round_score
	end
end

