class PagesController < ApplicationController

	def home
		@shows = Show.all
		@seasons = Season.where(expired: false)
	end

end
