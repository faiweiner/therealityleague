class CreatePoints < ActiveRecord::Migration
	def change
		create_table :points do |t|
			t.string :type
			t.integer :franchise_id
			t.string :event
			t.integer :points
			t.timestamps
		end
	end
end
