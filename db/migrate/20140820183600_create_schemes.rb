class CreateSchemes < ActiveRecord::Migration
	def change
		create_table :schemes do |t|
			t.string :type
			t.integer :show_id
			t.string :description
			t.integer :points_asgn
			t.timestamps
		end
	end
end
