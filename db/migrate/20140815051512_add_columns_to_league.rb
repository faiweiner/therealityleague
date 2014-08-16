class AddColumnsToLeague < ActiveRecord::Migration
  def change
    add_column :leagues, :league_key, :string
    add_column :leagues, :league_password, :string
  end
end
