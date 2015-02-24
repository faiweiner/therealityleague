# == Schema Information
#
# Table name: events
#
#  id            :integer          not null, primary key
#  contestant_id :integer
#  episode_id    :integer
#  scheme_id     :integer
#  points_earned :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Event < ActiveRecord::Base
	belongs_to :contestant
	belongs_to :episode
	belongs_to :scheme

	validates :contestant_id, presence: true
	validates :episode_id, presence: true
	validates :scheme_id, presence: true

	before_save :calculate_points
	before_save :check_event

	after_save :mark_elimination

	private

	def calculate_points
		points = Scheme.find(self.scheme_id).points_asgn
		self.points_earned = points
	end

	def check_event
		scheme = Scheme.find(self.scheme_id)
		if scheme.type == "Expulsion"
		end
	end

	def mark_elimination
		scheme = Scheme.find(self.scheme_id)
		season = Episode.find(self.episode_id).season
		if scheme.type == "Expulsion"
			status = Status.where(contestant_id: self.contestant_id, season_id: season.id).first
			status.eliminated_episode_id = self.episode_id
			status.present = false
			status.save
		end
	end
end

