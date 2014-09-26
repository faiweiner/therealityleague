class SchemasController < ApplicationController
	def index
		@shows = Show.all.order("name DESC")	
		@schema = Schema.new
	end

	def display
		@show = Show.find(params[:show_id])
		@schemas = @show.schemas
		render :partial => "display_schemas"
	end

	def create
		@schema = Schema.new schema_params
		if @schema.save
			redirect_to schemas_path
		else
			raise "no sorry"
		end
	end

	private

	def schema_params
		params.require(:schema).permit(:id, :type, :show_id, :description, :points_asgn)
	end
end
