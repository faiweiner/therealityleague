class SchemesController < ApplicationController
	def index
		@shows = Show.all.order("name DESC")	
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
			raise "no sorry"
		end
	end

	private

	def scheme_params
		params.require(:scheme).permit(:id, :type, :show_id, :description, :points_asgn)
	end
end
