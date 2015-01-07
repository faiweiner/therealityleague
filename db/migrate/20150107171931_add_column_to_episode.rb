class AddColumnToEpisode < ActiveRecord::Migration
  def change
  	add_column :episodes, :expected_survivors, :integer
  end
end
