class CreateJoinTableContestantsRounds < ActiveRecord::Migration
	def change
		create_join_table :contestants, :rounds, id: false do |t|
			t.integer :contestant_id
			t.integer :round_id
		end 	
	end
end
