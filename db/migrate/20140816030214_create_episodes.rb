class CreateEpisodes < ActiveRecord::Migration
	def change
		create_table :episodes do |t|
			t.integer 	:season_id
			t.datetime	:air_date
			t.boolean	 	:aired, default: :false
			t.integer		:expected_survivors
			t.timestamps
		end
	end
end
