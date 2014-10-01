class CreateContestants < ActiveRecord::Migration
  def change
		create_table :contestants do |t|
			t.string 	:name
			t.integer :season_id
			t.string	:image
			t.integer	:age
			t.string	:gender
			t.string	:occupation
			t.text		:description
			t.string 	:status_on_show
			t.boolean :present, default: :true
			t.integer	:episode_id 				# episode of elimination
			t.timestamps
		end
	end
end