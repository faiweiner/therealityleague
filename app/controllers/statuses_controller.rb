class StatusesController < ApplicationController
	before_action :check_if_admin
	layout "admin"

	def index
		@seasons = Season.where(expired: false)
		@count = 0
		@contestants = Contestant.all.order(name: :asc)
		@contestant = Contestant.new
		@status = Status.new
	end

	def new
	end
end