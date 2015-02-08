# == Schema Information
#
# Table name: seasons
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  number         :integer
#  show_id        :integer
#  premiere_date  :datetime
#  finale_date    :datetime
#  country_origin :string(255)
#  type           :string(255)
#  description    :text
#  episode_count  :integer
#  image          :string(255)
#  published      :boolean          default(FALSE)
#  expired        :boolean          default(FALSE)
#  created_at     :datetime
#  updated_at     :datetime
#  website        :string(255)
#  network        :string(255)
#

class Season < ActiveRecord::Base
	belongs_to :show, inverse_of: :seasons
	has_many :leagues, inverse_of: :season, dependent: :destroy
	has_many :schemes, through: :show
	has_and_belongs_to_many :contestants, inverse_of: :seasons
	has_many :episodes
	# belongs_to :score

	validates :name, :presence => true, :on => :create
	validates :premiere_date, :presence => true, :on => :create

	private
	
	def self.top_three
		# This model method is called in Pages#home to give list of the three top shows
		
		Season.where(expired: false).order("premiere_date ASC").last(3)
	end

	def self.select_season
		# This model method is for populating Create League's drop-down menu
		@seasons_list = Season.where(expired: false).each.map {|s| [s.name, s.id]}
	end

	# check method if season can be edited

	def self.list_by_show(show_id)
		seasons_show = Season.where(show_id: show_id)	
	end

	def get_points_by_season(season_id)
		season = Season.find(season_id)
		episodes_list = Episode.where(season_id: season_id)
		@points_season = []
		episode_list.each do |episode|
			@points_season << episode.points
		end
		return @points_season
	end
end
