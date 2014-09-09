# == Schema Information
#
# Table name: rounds
#
#  id         :integer          not null, primary key
#  league_id  :integer
#  episode_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Round < ActiveRecord::Base
	belongs_to :roster
	belongs_to :episode
	has_and_belongs_to_many :contestants, inverse_of: :rounds
	
	def pts_contestant(contestant_id)
		self.episode.contestants.find(contestant_id).points.inject(0) do |sum, point|
			sum += point.event.points_asgn
		end
	end
end

