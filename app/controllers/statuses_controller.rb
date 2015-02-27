class StatusesController < ApplicationController
	before_action :check_if_admin
	layout "admin"

	def index
		@contestants = Contestant.all
	end

	def new
		
	end
end