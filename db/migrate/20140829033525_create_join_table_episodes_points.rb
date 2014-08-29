class CreateJoinTableEpisodesPoints < ActiveRecord::Migration
	def change
		create_join_table :episodes, :points, id: false do |t|
			t.index [:episode_id, :point_id]
			t.index [:point_id, :episode_id]
		end
	end
end
