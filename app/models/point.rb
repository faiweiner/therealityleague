# == Schema Information
#
# Table name: points
#
#  id            :integer          not null, primary key
#  contestant_id :integer
#  episode_id    :integer
#  event_id      :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Point < ActiveRecord::Base
	belongs_to :contestant
	belongs_to :episode
	belongs_to :event

	validates :contestant_id, presence: true
end

