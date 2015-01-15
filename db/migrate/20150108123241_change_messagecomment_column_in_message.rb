class ChangeMessagecommentColumnInMessage < ActiveRecord::Migration
	def change
		change_column :messages, :messagecomment, :text
	end
end
