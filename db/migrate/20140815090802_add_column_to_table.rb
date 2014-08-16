class AddColumnToTable < ActiveRecord::Migration
  def change
    add_column :rosters, :created_at, :timestamp
    add_column :rosters, :updated_at, :timestamp
  end
end
