class CreateEpisodes < ActiveRecord::Migration
	def change
		create_table :episodes do |t|
			t.integer :season_id
			t.datetime :air_date
			t.timestamps
		end
	end
end
