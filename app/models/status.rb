# == Schema Information
#
# Table name: statuses
#
#  contestant_id         :integer          primary key
#  season_id             :integer
#  present               :boolean          default(TRUE)
#  eliminated_episode_id :integer
#

class Status < ActiveRecord::Base
	self.primary_key = :contestant_id
	belongs_to :contestant
	belongs_to :season
	belongs_to :episode
end
