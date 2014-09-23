module ApplicationHelper
	
	def pluralize_without_count(count, noun, text = nil)
	 if count != 0
			count == 1 ? "#{noun}#{text}" : "#{noun.pluralize}#{text}"
		end
	end
end 

# link_to("Settings", edit_user_path(@current_user))