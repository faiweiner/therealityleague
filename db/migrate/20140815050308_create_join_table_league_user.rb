class CreateJoinTableLeagueUser < ActiveRecord::Migration
	def change
		create_join_table :leagues, :users, id: false do |t|
			t.integer :league_id
			t.integer :user_id
		end
	end
end
