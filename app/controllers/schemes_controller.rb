class SchemesController < ApplicationController
	layout "admin"
	def index
		@shows = Show.all.order(name: :desc)	
		@selected = Scheme.all.order(type: :asc, points_asgn: :asc, description: :asc, show_id: :asc)
		@scheme = Scheme.new
	end

	def display_all
		@selected = Scheme.all.order(type: :asc, points_asgn: :asc, description: :asc, show_id: :asc)
		respond_to do |format|
				format.js
		end
	end

	def create
		@scheme = Scheme.new scheme_params
		if @scheme.save
			@selected = Scheme.where(:show_id => params[:show_id]).order(type: :asc, points_asgn: :asc, description: :asc)
			respond_to do |format|
					format.js
			end			
		else
			raise
			flash[:notice] = "Something went wrong and the scheme was not saved."
			flahs[:color] = "alert-warning warning"
		end
		raise
	end

	def from_show
		@selected = Scheme.where(:show_id => params[:show_id]).order(type: :asc, points_asgn: :asc, description: :asc)
		respond_to do |format|
				format.js
		end
	end



	private

	def scheme_params
		params.require(:scheme).permit(:id, :type, :show_id, :description, :points_asgn)
	end
end
