class CreateJointTableContestantsRosters < ActiveRecord::Migration
	def change
		create_table :contestants_rosters do |t|
			t.integer :roster_id
			t.integer :contestant_id
		end
	end
end
