class AddColumnToShows < ActiveRecord::Migration
  def change
    add_column :shows, :image, :string
    add_column :shows, :series_id, :integer
    add_column :shows, :expired, :boolean, default: false
    add_column :contestants, :image, :string
  end
end
