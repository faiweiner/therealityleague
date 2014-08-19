class ShowsController < ApplicationController
	def index
		@shows = Show.all.order("name ASC")
	end
end
