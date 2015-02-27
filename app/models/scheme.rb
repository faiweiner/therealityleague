# == Schema Information
#
# Table name: schemes
#
#  id          :integer          not null, primary key
#  type        :string(255)
#  description :string(255)
#  points_asgn :integer
#  created_at  :datetime
#  updated_at  :datetime
#  show_id     :integer
#

class Scheme < ActiveRecord::Base
	belongs_to :show, inverse_of: :schemes

	has_many :events
	has_many :contestants, through: :events
	has_many :episodes, through: :events
	has_and_belongs_to_many :leagues
	has_and_belongs_to_many :schemes
	has_and_belongs_to_many :shows

	validates :type, presence: true, allow_blank: false
	validates :show_id, presence: true, allow_blank: false
	validates :description, presence: true, allow_blank: false
	validates :points_asgn, presence: true, allow_blank: false
	
	private

	def self.select_scheme
		@schemes_list = Scheme.all.each.map {|s| [s.description, s.type, s.id]}
		@schemes_list.unshift(["Select a scheme", nil])
	end

	def self.select_type
		@type_list = Scheme.descendants.map(&:name).sort
		@type_list.unshift(["Select type", nil])
		@type_list.push(["Add new type", nil])
	end

	def self.list_schemes(episode_id)
		show = Episode.find(episode_id).season.show.schemes.order(type: :asc, description: :asc)
	end

end
