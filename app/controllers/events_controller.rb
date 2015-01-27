class EventsController < ApplicationController
	layout "admin"
	def index
		# get data for dynamic drop-down
		@shows = Show.all
		@seasons = Season.where(expired: false)

		# all events
		@events_all = Event.all
		@events_info_table = {}
		@events_all.each do |event|
			season = event.episode.season
			episode = event.episode
			contestant = event.contestant.name
			description = generate_half_sentence(event.scheme.description)
			pts = event.scheme.points_asgn
			event_description = contestant + description
			event_data = {
				:season => season,
				:episode => episode,
				:scheme => event_description,
				:points_assigned => pts
			}
			@events_info_table[event.id] = event_data
		end
		@table_header = "Events Table"
	end

	def new
		@shows = Show.all
		@seasons = Season.where(expired: false)
		@event = Event.new
	end

	def create
		raise params
		#====== check for bad entry ======#
		@event = Event.new event_param
		event_episode = @event.episode
				
		# event_show = Show.find(params[:show_list])
		# event_season = Season.find(params[:season_list])

		# event_contestant = Contestant.find(params[:event][:contestant_id])
		# event_scheme = Scheme.find(params[:event][:scheme_id])

		if @event && @event.save
			render partial: "display_points"
		else
			render :new
		end

	end

	def update
		@event = Event.find(params[:event_id])
		if @event.update
			raise "hell"
		else
			raise "nope"
		end
	end

	def destroy
		@event = Event.find(params[:event_id])
		if @event.destroy
			flash[:notice] = "Event \##{@event.id}: \"#{@event.contestant.name} #{@event.scheme.description}\" has been successfully deleted."
			flash[:color] = "alert-success"
			render partial: "display_points"
		else
			flash[:notice] = "Something went wrong, please try again."
			flash[:color] = "alert-danger"
			render partial: "display_points"
		end
	end

	def display
		@season = Season.find_by("id = ?", params[:season_id])
		@episode = Episode.find_by("id = ?", params[:episode_id])	
		@events = Event.where(:episode_id => @episode.id).order(created_at: :desc)
		@table_header = "Event Table"
		if @episode.present?
			@table_header = "#{@episode.season.show.name}: #{@episode.season.name} - Episode #{@episode.air_date.strftime("%D")}"
		end
		render partial: "display_points"
	end

	def get_seasons
		@seasons = Season.where("show_id = ?", params[:show_id])
		respond_to do |format|
			format.js
		end
	end

	private

	def event_param
		params.require(:event).permit(:contestant_id, :episode_id, :scheme_id)
	end

	def generate_half_sentence(string)
		string.gsub!("Contestant", "")
		return string
	end

	# Generate
	def points_by_season(season_id)
		episodes_season_list = Episode.where(season_id: season_id)
		@events_all.where(episode_id: season_id)
	end
end
