class PagesController < ApplicationController
	before_action :featured_shows

	def home
		featured_shows 		# Model method from Show
		# user_leagues_list	# Model method from User
	end

	def sign_in
		
	end
end
