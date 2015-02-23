# == Schema Information
#
# Table name: statuses
#
#  contestant_id      :integer
#  season_id          :integer
#  present            :boolean          default(TRUE)
#  eliminated_episode :integer
#

class Status < ActiveRecord::Base
	belongs_to :contestant
	belongs_to :season
end
