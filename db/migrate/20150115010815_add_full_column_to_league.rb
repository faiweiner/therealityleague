class AddFullColumnToLeague < ActiveRecord::Migration
  def change
    add_column :leagues, :full, :boolean, default: false
  end
end
