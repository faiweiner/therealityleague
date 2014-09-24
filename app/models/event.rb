# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  type        :string(255)
#  show_id     :integer
#  event       :string(255)
#  points_asgn :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Event < ActiveRecord::Base
	belongs_to :show, inverse_of: :events

	has_many :points
	has_many :contestants, through: :points
	has_many :episodes, through: :points

	private

	def self.select_event
		@events_list = Event.all.each.map {|e| [e.event, e.type, e.id]}
		@events_list.unshift(["Select an event", nil])
	end

	def self.select_type
		# FIXME - make type_list scalable
		@type_list = ["Survival", "Game", "Extracurricular"]
	end
end
