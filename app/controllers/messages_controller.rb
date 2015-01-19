class MessagesController < ApplicationController
	layout "admin"
	before_action :check_if_logged_in
	before_action :check_if_admin

	def index
		@unresolved_messages = Message.where(resolved: false)
		@resolved_messages = Message.where(resolved: true)
	end
	def new
		
	end

	def create
		@message = Message.new
		@message.user_id = params[:message][:user_id]
		@message.messagetype = params[:message][:messagetype]
		@message.messagecomment = params[:message][:messagecomment]
		@message.page_url = params[:message][:pageurl]
		if @message.save
			respond_to do |format|
				format.js {
					render :json => {
						:success => "Thank you, your comment has been submitted."
					}
				}
			end
		else
			respond_to do |format|
				format.json { 
					render :json => { :error => "You must be logged in to submit a comment." }, 
					:status => 422 
				}
				format.js { 
					render :json => @person.errors, :status => :unprocessable_entity }
			end
		end

	end

end