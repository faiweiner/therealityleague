class RenameEliminatedEpisodeInStatuses < ActiveRecord::Migration
  def change
  	rename_column :statuses, :eliminated_episode, :eliminated_episode_id
  end
end
