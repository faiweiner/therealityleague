class AddColumnToEpisode < ActiveRecord::Migration
  def change
    add_column :episodes, :air_date, :datetime
  end
end
