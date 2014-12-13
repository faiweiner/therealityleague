class CreateLeagues < ActiveRecord::Migration
	def change
		create_table :leagues do |t|
			t.string 		:name
			t.integer 	:commissioner_id
			t.integer 	:season_id
			t.boolean 	:public_access, :default => true
			t.string		:type
			t.integer		:participant_cap
			t.integer		:draft_limit
			t.datetime	:draft_deadline
			t.string		:draft_order
			t.integer		:scoring_system
			t.string 		:league_key
			t.string 		:league_password
			t.boolean		:active, default: :true
			t.timestamps
		end
	end
end