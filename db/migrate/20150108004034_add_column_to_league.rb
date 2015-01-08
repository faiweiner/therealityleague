class AddColumnToLeague < ActiveRecord::Migration
  def change
    add_column :leagues, :locked, :boolean, default: false
  end
end
