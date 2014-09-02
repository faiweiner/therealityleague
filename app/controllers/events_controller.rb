class EventsController < ApplicationController
	def index
		@shows = Show.all.order("name DESC")	
	end

end
