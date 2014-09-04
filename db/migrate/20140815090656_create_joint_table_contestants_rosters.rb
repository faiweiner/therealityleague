class CreateJointTableContestantsRosters < ActiveRecord::Migration
	def change
		create_join_table :contestants, :rosters, id: false do |t|
			t.integer :contestant_id
			t.integer :roster_id
		end
	end
end
