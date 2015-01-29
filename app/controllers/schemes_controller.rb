class SchemesController < ApplicationController
	layout "admin"
	def index
		@shows = Show.all.order(name: :desc)	
		@schemes = Scheme.all.order(type: :asc, points_asgn: :asc, description: :asc, show_id: :asc)
		@scheme = Scheme.new
	end

	def display
		@show = Show.find(params[:show_id])
		@schemes = @show.schemes
		render :partial => "display_schemes"
	end

	def create
		@scheme = Scheme.new scheme_params
		if @scheme.save
			redirect_to schemes_path
		else
			flash[:notice] = "Something went wrong and the scheme was not saved."
			flahs[:color] = "alert-warning warning"
		end
	end

	private

	def scheme_params
		params.require(:scheme).permit(:id, :type, :show_id, :description, :points_asgn)
	end
end
