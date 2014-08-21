class AddColumnToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :expired, :boolean, default: :false
  end
end
