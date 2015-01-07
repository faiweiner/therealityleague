class MessagesController < ActionController::Base

	def index
		
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