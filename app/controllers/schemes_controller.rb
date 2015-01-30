class SchemesController < ApplicationController
	layout "admin"
	def index
		@shows = Show.all.order(name: :asc)	
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
			flash[:notice] = "New scheme has been successfully added."
			flash[:color] = "alert-success success"
			respond_to do |format|
				format.json {
					render :json => {
						:schemeList => @selected,
						:notice => flash[:notice],
						:color => flash[:color]
					}
				}
			end
		elsif @scheme.errors
			flash[:notice] = "Invalid - Please fix the below before submitting:"
			flash[:color] = "alert-warning warning"
			respond_to do |format|
				format.json {
					render :json => {
						:errors => @scheme.errors.full_messages,
						:notice => flash[:notice],
						:color => flash[:color],
						:success => false
					}, :status => 400
				}
			end
		end
	end

	def edit
		@scheme = Scheme.find(params[:id])
		respond_to do |format|
			format.json {
				render :json => {
					:scheme => @scheme,
				}, :status => 200
			}
		end
	end

	def update
		@scheme = Scheme.find(params[:id])
		raise
		if @scheme.update scheme_params
			flash[:notice] = "Scheme has been successfully updated."
			flash[:color] = "alert-success success"
		else
			@scheme.errors
			flash[:notice] = "Something went wrong and the scheme was not updated."
			flash[:color] = "alert-warning warning"
		end
	end

	def from_show
		@selected = Scheme.where(:show_id => params[:show_id]).order(type: :asc, points_asgn: :asc, description: :asc)
		respond_to do |format|
				format.js
		end
	end

	def destroy
		@scheme = Scheme.find params[:id]
		if	@scheme.destroy
			flash[:notice] = "Scheme\##{@scheme.id} has been successfully deleted."
			flash[:color] = "alert-success"
		else
			flash[:notice] = "Something went wrong, please try again."
			flash[:color] = "alert-danger"
		end
		redirect_to schemes_path
	end

	private

	def scheme_params
		if params[:type_select].present? || params[:type_text].present?
			if params[:type_text].present?
				params[:scheme][:type] = params[:type_text]
			elsif params[:type_select].present?
				case params[:type_select]
				when "Select type"
					params[:scheme][:type] = nil
				when "Add new type"
					params[:scheme][:type] = nil
				else
					params[:scheme][:type] = params[:type_select]
				end
			else
				params[:scheme][:type] = params[:scheme][:type]
			end
		else
			if params[:type_text].present?
				params[:type] = params[:type_text]
			elsif params[:type_select].present?
				case params[:type_select]
				when "Select type"
					params[:type] = nil
				when "Add new type"
					params[:type] = nil
				else
					params[:type] = params[:type_select]
				end
			else
				params[:type]
			end
		end
		params.require(:scheme).permit(:id, :type, :show_id, :description, :points_asgn)
	end
end
