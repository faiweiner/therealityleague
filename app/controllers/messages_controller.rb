class MessagesController < ActionController::Base

	def index
		
	end
	def new
		
	end

	def create
		if @current_user 
			@message = Message.new
			@message.user_id = @current_user.id
			if @message.save	
				@message.save
				respond_to do |format|
					format.js {
						render :json => {
							:success => "Thank you, your comment has been submitted."
						}
					}
				end
			else
				respond_to do |format|
					format.js {
						render :json => {
							:error => "Something went wrong and your message has not been submitted, please try again."
						}
					}
				end
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