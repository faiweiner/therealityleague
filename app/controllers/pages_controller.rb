class PagesController < ApplicationController
	before_action :featured_seasons

	def home
		featured_seasons		# Model method from Season
		# user_leagues_list	# Model method from User
	end

end
