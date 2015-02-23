class CreateStatuses < ActiveRecord::Migration
	def change
		create_table :statuses, id: false do |t|
			t.integer :contestant_id
			t.integer :season_id
			t.boolean :present, default: :true
			t.integer	:eliminated_episode		
		end 
	end
end
