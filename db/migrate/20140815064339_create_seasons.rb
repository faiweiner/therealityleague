class CreateSeasons < ActiveRecord::Migration
	def change
		create_table :seasons do |t|
			t.string 		:name
			t.integer		:number
			t.integer		:show_id
			t.datetime 	:premiere_date
			t.datetime	:finale_date
			t.string 		:country_origin
			t.string 		:type
			t.text			:description
			t.integer		:episode_count
			t.string		:image
			t.boolean		:published, default: :false
			t.boolean		:expired, default: :false
			t.timestamps
		end
	end
end