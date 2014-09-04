class CreateEvents < ActiveRecord::Migration
	def change
		create_table :events do |t|
			t.string :type
			t.integer :show_id
			t.string :event
			t.integer :points_asgn
			t.timestamps
		end
	end
end
