class PagesController < ApplicationController
	before_action :featured_seasons

	def home
		featured_seasons
		if @current_user && @current_user.leagues.count > 0
			@league_count = @current_user.leagues.count
		else
			@league_count = 0
		end

		respond_to do |format|
			format.html
			format.json {
				render json: @league_count
			}
		end

	end

end
