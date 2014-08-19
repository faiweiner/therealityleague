module ApplicationHelper
	def smartnav
		links = ""
		if @current_user.present?
			links += "<li class='dropdown'>"
			links += link_to("#{@current_user.username}", user_path(@current_user), :class => "dropdown-toggle", :data => {:toggle=>"dropdown"})
			links += "</li>"
			links += "<li>"
			links += link_to("Logout", login_path, :data => {:method => :delete, :confirm => 'Really logout?'})
			links += "</li>"
		else
			links += "<li>"
			links += link_to("Sign Up", new_user_path)
			links += "</li>"
			links += "<li>"
			links += link_to("Sign In", login_path)
			links += "</li>"
		end
		links
	end
end


# link_to("Settings", edit_user_path(@current_user))