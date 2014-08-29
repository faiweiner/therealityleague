class CreateJoinTableContestantsPoints < ActiveRecord::Migration
  def change
  	create_join_table :contestants_points, id: false do |t|
			t.integer :contestant_id
			t.integer :point_id
		end
  end
end
