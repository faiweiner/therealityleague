class AddEpisodeCountToShows < ActiveRecord::Migration
  def change
    add_column :shows, :episode_count, :integer
    change_column :shows, :description, :text
  end
end
