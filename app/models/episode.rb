# == Schema Information
#
# Table name: episodes
#
#  id         :integer          not null, primary key
#  season_id  :integer
#  air_date   :datetime
#  created_at :datetime
#  updated_at :datetime
#

class Episode < ActiveRecord::Base
	belongs_to :season
	has_many :rounds

	has_many :events
	has_many :contestants, through: :events
	has_many :schemas, through: :events

	validates :season_id, :presence => true
	validates :air_date, :presence => true

	def self.select_episode
		@episodes_list = Episode.all.each_with_index.map {|e| [e.air_date.strftime("%m/%d/%Y"), e.id] }
		@episodes_list.unshift(["Select an episode", nil])
	end
end
