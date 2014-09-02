class EventsController < ApplicationController
	def index
		@shows = Show.all.order("name DESC")	
		@event = Event.new
	end

	def display
		@show = Show.find(params[:show_id])
		@events = @show.events
		render :partial => "display_events"
	end

	def create
		@event = Event.new event_params
		if @event.save
			redirect_to events_path
		else
			raise "no sorry"
		end
	end

	private

	def event_params
		params.require(:event).permit(:id, :type, :show_id, :event, :points_asgn)
	end
end
