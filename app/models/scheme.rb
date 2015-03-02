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
	has_and_belongs_to_many :shows

	validates :type, presence: true, allow_blank: false
	validates :description, presence: true, allow_blank: false
	validates :points_asgn, presence: true, allow_blank: false
	
	before_destroy :scheme_with_show?, :scheme_with_event?

	def scheme_with_show?
		errors[:base] << "Cannot delete scheme with shows."
		return false if self.shows.any?
	end

	def scheme_with_event?
		errors[:base] <<  "Cannot delete scheme with events."
		return true if self.events.count == 0
	end

	def assign_shows(show_ids)
		linked_shows = []
		nonlinked_shows = []
		shows = Show.all
		shows.each do |show|
			if show_ids && ( show_ids.include? show.id.to_s )
				puts "YESsssssss"
				linked_shows << show 
			else
				puts "NO"
				nonlinked_shows << show
			end
		end
		nonlinked_shows.each {|show| self.shows.delete(show)}
		linked_shows.each {|show| self.shows << show unless self.shows.include? show}
	end

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

	def self.list_types
		@type_list = Scheme.descendants.map(&:name).sort
		@type_list.unshift(["All Schemes", "All"])
	end
end
