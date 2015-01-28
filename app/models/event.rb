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
	before_save :set_contestant_status

	private

	def calculate_points
		points = Scheme.find(self.scheme_id).points_asgn
		self.points_earned = points
	end

	def set_contestant_status
		
	end
end

