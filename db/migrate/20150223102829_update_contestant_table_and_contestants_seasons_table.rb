class UpdateContestantTableAndContestantsSeasonsTable < ActiveRecord::Migration
	def change
		remove_column :contestants, :status_on_show, :text
		remove_column :contestants, :present, :boolean
		remove_column :contestants, :episode_id, :integer
	end
end
