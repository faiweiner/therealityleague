# == Schema Information
#
# Table name: shows
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  image      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Show < ActiveRecord::Base
	has_many :seasons, inverse_of: :show, dependent: :destroy
	has_many :episodes, through: :seasons
	has_many :events, through: :schemes
	has_and_belongs_to_many :schemes

	validates :name, presence: true, uniqueness: true,  on: :create
	
	def self.search_show(query)
		where("name LIKE ?", "%#{query}%")
	end

	def self.get_show_names
		@show_name = Show.select(:name).each.map{|s| s.name }
	end

	def self.select_show
		# This model method is for populating Create League's drop-down menu
		@shows_list = Show.uniq.order("name ASC").each.map {|s| [s.name, s.id] }
	end

	def self.select_show_all
		@shows_list = Show.all.order("name ASC").each.map {|s| [s.name, s.id] }
	end

	def self.get_schemes(show_id)
		show = Show.find(show_id)
		@rules = show.schemes
	end
end
