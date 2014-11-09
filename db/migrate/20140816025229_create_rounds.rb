class CreateRounds < ActiveRecord::Migration
	def change
		create_table :rounds do |t|
			t.integer		:user_id
			t.integer		:league_id
			t.integer		:episode_id
			t.timestamps
		end
	end
end
