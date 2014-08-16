class AddColumnToShow < ActiveRecord::Migration
  def change
    add_column :shows, :description, :string
  end
end
