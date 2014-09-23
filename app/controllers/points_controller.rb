class PointsController < ApplicationController
	def index
		# get data for dynamic drop-down
		@shows = Show.all
		@seasons = Season.where("show_id = ?", Show.first.id)

		# all points
		@points_all = Point.all
		@points_info_table = {}
		@points_all.each do |point|
			contestant = point.contestant.name
			event = generate_half_sentence(point.event.event)
			pts = point.event.points_asgn
			points_description = contestant + event
			@points_info_table[points_description] = pts
		end
	end

	def new
		@point = Point.new
	end

	def create
		@point = Point.new point_param
		if @point.save
			redirect_to points_path
		else
			render :new
		end
	end

	def update
		
	end

	def delete
		
	end

	def display
		@season = Season.find_by("id = ?", params[:point_entry][:season_id])	
	end

	def get_seasons
		@seasons = Season.where("show_id = ?", params[:show_id])
		respond_to do |format|
			format.js
		end
	end

	private

	def point_param
		params.require(:points).permit(:contestant_id, :episode_id, :event_id)
	end

	def generate_half_sentence(string)
		string.gsub!("Contestant", "")
		return string
	end

	# Generate a 
	def points_by_season(season_id)
		episodes_season_list = Episode.where(season_id: season_id)
		@points_all.where(episode_id: season_id)
	end


end
