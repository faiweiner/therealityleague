class AddAiredToEpisode < ActiveRecord::Migration
  def change
    add_column :episodes, :aired, :boolean, default: false
  end
end
