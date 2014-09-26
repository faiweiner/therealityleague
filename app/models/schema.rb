# == Schema Information
#
# Table name: schemas
#
#  id          :integer          not null, primary key
#  type        :string(255)
#  show_id     :integer
#  description :string(255)
#  points_asgn :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Schema < ActiveRecord::Base
	belongs_to :show, inverse_of: :schemas

	has_many :events
	has_many :contestants, through: :events
	has_many :episodes, through: :events

	private

	def self.select_schema
		@schemas_list = Event.all.each.map {|s| [s.description, s.type, s.id]}
		@schemas_list.unshift(["Select a schema", nil])
	end

	def self.select_type
		# FIXME - make type_list scalable
		@type_list = ["Survival", "Game", "Extracurricular"]
	end
end
