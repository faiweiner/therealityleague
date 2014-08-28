class CreateRounds < ActiveRecord::Migration
	def change
		create_table :rounds do |t|
			t.integer :league_id
			t.integer :episode_id
			t.timestamps
		end
	end
end
