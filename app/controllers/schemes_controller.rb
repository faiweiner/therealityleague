class SchemesController < ApplicationController
	layout "admin"
	def index
		@form_header = "New Scheme"
		@shows = Show.all.order(name: :asc)	
		@show_id = nil
		@schemes = {}
		schemes = Scheme.all.order(type: :asc, description: :asc, points_asgn: :asc)
		schemes.each do |scheme|
			@schemes[scheme] = false
		end
		@scheme = Scheme.new
	end

	def new
		@scheme = Scheme.new
		render :partial => "form"
	end

	def create
		puts params
		puts "on create"
		@scheme = Scheme.new scheme_params
		puts @scheme.inspect
		if @scheme.save	
			@selected = Scheme.where(:show_id => params[:show_id]).order(type: :asc, points_asgn: :asc, description: :asc)	
			flash[:notice] = "New scheme has been successfully added."
			flash[:color] = "alert-success success"
			respond_to do |format|
				format.json {
					render :json => {
						:schemeList => @selected,
						:scheme_id => @scheme.id,
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
		@form_header = "Update Scheme"
		scheme = Scheme.find(params[:id])
		scheme_shows = {}

		scheme.shows.each_with_index do |show, i| 
			scheme_shows[i] = {}
			scheme_shows[i][:id] = show.id
			if scheme.shows.include? show
				scheme_shows[i][:include] = true
			else
				scheme_shows[i][:include] = false
			end
		end

		respond_to do |format|
			format.json {
				render :json => {
					:scheme => scheme,
					:shows => scheme_shows,
					:type => scheme.type
				}, :status => 200
			}
		end
	end

	def method_name
		
	end

	def update
		@scheme = Scheme.find(params[:id])
		shows = Show.all
		scheme_shows = {}

		shows.each_with_index do |show, i| 
			scheme_shows[i] = {}
			scheme_shows[i][:id] = show.id
			if @scheme.shows.include? show
				scheme_shows[i][:include] = true
			else
				scheme_shows[i][:include] = false
			end
		end

		if params[:showIdsList] 
			show_ids_list = params[:showIdsList] 
			show_ids_list.each do |show_id|
				show = Show.find(show_id)
				scheme.shows << show unless scheme.shows.include? show
			end
		end

		if @scheme.update scheme_params
			@schemes = {}
			schemes = Scheme.all.order(type: :asc, description: :asc, points_asgn: :asc)
			schemes.each do |scheme|
				@schemes[scheme] = false
			end
			flash[:notice] = "Scheme has been successfully updated."
			flash[:color] = "alert-success success"
			respond_to do |format|
				format.html { render partial: "display_schemes", locals: {schemes: @schemes} }
				format.json {
					render :json => {
						:scheme => @scheme,
						:type => @scheme.type,
						:shows => @scheme.scheme_shows,
						:notice => flash[:notice],
						:color => flash[:color]
					}, :status => 200
				}
			end
		else
			@scheme.errors
			flash[:notice] = "Something went wrong and the scheme was not updated."
			flash[:color] = "alert-warning warning"
			respond_to do |format|
				format.js
				format.json {
					render :json => {
						:scheme => @scheme,
						:type => @scheme.type,
						:notice => flash[:notice],
						:color => flash[:color]
					}, :status => 400
				}
			end	
		end
	end

	def from_show
		@show_id = nil
		@schemes = {}
		unless params[:show_id] == "All"
			@show_id = params[:show_id]
			schemes = Scheme.where(show_id: params[:show_id]).order(type: :asc, description: :asc, points_asgn: :asc)
			show = Show.find(params[:show_id])
			schemes.each do |scheme|
				if show.schemes.include? scheme
					@schemes[scheme] = true
				else
					@schemes[scheme] = false
				end
			end
		else
			schemes = Scheme.all.order(type: :asc, description: :asc, points_asgn: :asc)
			schemes.each do |scheme|
				@schemes[scheme] = false
			end
		end
		respond_to do |format|
			format.js
		end
	end

	def destroy
		@scheme = Scheme.find params[:id]
		if @scheme.shows.count == 0 && @scheme.events.count == 0
			if @scheme.destroy
				flash[:notice] = "Scheme\##{@scheme.id} has been successfully deleted."
				flash[:color] = "alert alert-success"
			else
				flash[:notice] = "Cannot destroy."
				flash[:color] = "alert alert-danger"
			end
		else
			flash[:notice] = "Delete prohibited. Scheme with shows and/or events cannot be deleted."
			flash[:color] = "alert alert-danger"
		end
		redirect_to schemes_path
	end

	private

	def setSchemeType(params)
		puts params
		if params[:type_select].present?
			case params[:type_select]
			when "Select type"
				params[:scheme][:type] = nil
			when "Add new type"
				params[:scheme][:type] = nil
			else
				params[:scheme][:type] = params[:type_select]
			end
		elsif params[:type_text].present?
			params[:scheme][:type] = params[:type_text]
		else
			return
		end
		return params
	end

	def scheme_params
		setSchemeType(params)
		params.require(:scheme).permit(:id, :type, :description, :points_asgn)
	end
end
