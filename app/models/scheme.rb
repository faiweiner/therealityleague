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
	# cannot delete scheme if shows/events attached

	def scheme_with_show?
		errors[:base] << "Cannot delete scheme with shows."
		return false if self.shows.any?
	end

	def scheme_with_event?
		errors[:base] <<  "Cannot delete scheme with events."
		return false if self.events.any?
	end

	def assign_shows(show_ids)
		linked_shows = []
		nonlinked_shows = []
		shows = Show.all
		shows.each do |show|
			if show_ids && ( show_ids.include? show.id.to_s )
				linked_shows << show 
			else
				nonlinked_shows << show
			end
		end
		nonlinked_shows.each {|show| self.shows.delete(show)}
		linked_shows.each {|show| self.shows << show unless self.shows.include? show}
	end

	private

	def self.filter_search(queries_hash)
		scenario = []
		results = []

		# 1.A If either queries exist, then proceed
		if queries_hash[:show_id] || queries_hash[:type]
			# 1.A.A If YES show_id
			if queries_hash[:show_id]
				show = Show.find(queries_hash[:show_id])
				# 1.A.A.A YES show_id && YES type
				if queries_hash[:type].present?
					schemes = show.schemes.order(type: :asc, description: :asc, points_asgn: :asc).select{|scheme| scheme.type == queries_hash[:type]}
				# 1.A.A.B YES show_id && NO type
				else
					schemes = show.schemes.order(type: :asc, description: :asc, points_asgn: :asc)
				end
			# 1.A.B If NO show_id 
			else
				# NO show_id, YES type
				if queries_hash[:type].present?
					schemes = Scheme.where(type: queries_hash[:type]).order(type: :asc, description: :asc, points_asgn: :asc)
				end
			end
		# 1.B If both queries are "All"
		else
			schemes = Scheme.all.order(type: :asc, description: :asc, points_asgn: :asc)
		end
		results = schemes
	end

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
