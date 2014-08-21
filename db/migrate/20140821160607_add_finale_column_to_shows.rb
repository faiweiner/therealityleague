class AddFinaleColumnToShows < ActiveRecord::Migration
  def change
    add_column :shows, :shows, :string
    add_column :shows, :finale_date, :datetime
  end
end
