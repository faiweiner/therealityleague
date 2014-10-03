class PagesController < ApplicationController

	def home
		@featured_seasons = Season.top_three
		if @current_user && @current_user.leagues.count > 0
			@league_count = @current_user.leagues.count
		else
			@league_count = 0
		end

		respond_to do |format|
			format.html
			format.js {
				render json: @league_count
			}
		end

	end

end
