# == Schema Information
#
# Table name: schemes
#
#  id          :integer          not null, primary key
#  type        :string(255)
#  show_id     :integer
#  description :string(255)
#  points_asgn :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Scheme < ActiveRecord::Base
	belongs_to :show, inverse_of: :schemes

	has_many :events
	has_many :contestants, through: :events
	has_many :episodes, through: :events

	private

	def self.select_scheme
		@schemes_list = Event.all.each.map {|s| [s.description, s.type, s.id]}
		@schemes_list.unshift(["Select a scheme", nil])
	end

	def self.select_type
		# FIXME - make type_list scalable
		@type_list = ["Survival", "Game", "Extracurricular"]
	end
end