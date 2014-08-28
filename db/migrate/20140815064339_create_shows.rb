class CreateShows < ActiveRecord::Migration
	def change
		create_table :shows do |t|
			t.string 		:name
			t.datetime 	:premiere_date
			t.datetime	:finale_date
			t.string 		:country_origin
			t.string 		:type
			t.text			:description
			t.integer		:episode_count
			t.string		:image
			t.integer		:series_id
			t.boolean		:published, default: :false
			t.boolean		:expired, deafult: :false
			t.timestamps
		end
	end
end