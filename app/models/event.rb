# == Schema Information
#
# Table name: events
#
#  id            :integer          not null, primary key
#  contestant_id :integer
#  episode_id    :integer
#  schema_id     :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Event < ActiveRecord::Base
	belongs_to :contestant
	belongs_to :episode
	belongs_to :schema

	validates :contestant_id, presence: true
	validates :episode_id, presence: true
	validates :schema_id, presence: true
end

