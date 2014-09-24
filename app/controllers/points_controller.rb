class PointsController < ApplicationController
	def index
		# get data for dynamic drop-down
		@shows = Show.all
		@seasons = Season.where("show_id = ?", Show.first.id)

		# all points
		@points_all = Point.all
		@points_info_table = {}
		@points_all.each do |point|
			season = point.episode.season
			episode = point.episode
			contestant = point.contestant.name
			event = generate_half_sentence(point.event.event)
			pts = point.event.points_asgn
			point_description = contestant + event
			point_data = {
				:season => season,
				:episode => episode,
				:event => point_description,
				:points_assigned => pts}
			@points_info_table[point.id] = point_data
		end
	end

	def new
		@point = Point.new
	end

	def create
		if params[:point_entry][:show_select] == ""
		#====== check for bad entry ======#
		point_show = Show.find(params[:point_entry][:show_select])
		point_season = Season.find(params[:point_entry][:season_select])
		point_contestant = Contestant.find(params[:point_entry][:contestant_select])
		point_event = Event.find(params[:point_entry][:event_select])
		if point_season.show_id != point_show.id
			#---- if selected season doesn't belong to the show
			flash[:notice] = "Invalid entry: selected season does not belong to the selected show."
			flash[:color] = "invalid"
			render :new
		elsif point_season.contestants.exclude? point_contestant
			#---- if selected contestant does not belong to the season
			flash[:notice] = "Invalid entry: selected contestant does not belong to the selected season."
			flash[:color] = "invalid"
			render :new
		elsif point_show.events.exclude? point_event
			#---- if event does not belong to the show
			flash[:notice] = "Invalid entry: selected contestant does not belong to the selected season."
			flash[:color] = "invalid"
			render :new
		else
			#---- if all is good
			new_params = {
				:contestant_id => params[:point_entry][:contestant_select], 
				:episode_id => params[:point_entry][:episode_select], 
				:event_id => params[:point_entry][:event_select]}
			@point = Point.new new_params
		end

		if @point.save
			raise "what are you saving?"
			redirect_to points_path
		else
			render :new
		end
	end

	def update
		
	end

	def delete
		raise "got to delete"
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

	# Generate
	def points_by_season(season_id)
		episodes_season_list = Episode.where(season_id: season_id)
		@points_all.where(episode_id: season_id)
	end
end
