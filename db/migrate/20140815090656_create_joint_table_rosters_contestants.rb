class CreateJointTableRostersContestants < ActiveRecord::Migration
	def change
		create_table :rosters_contestants do |t|
			t.integer :roster_id
			t.integer :contestant_id
		end
	end
end
