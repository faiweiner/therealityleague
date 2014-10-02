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
	has_many :schemes, inverse_of: :show, dependent: :destroy
	has_many :episodes, through: :seasons
	has_many :events, through: :schemes

	validates :name, :presence => true, :on => :create
	
	def self.search_show(query)
		where("name LIKE ?", "%#{query}%")
	end

	def self.select_show
		# This model method is for populating Create League's drop-down menu
		@shows_list = Show.all.each.map {|s| [s.name, s.id] }
	end
end
