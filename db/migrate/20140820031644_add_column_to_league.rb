class AddColumnToLeague < ActiveRecord::Migration
  def change
  	add_column :leagues, :draft_limit, :integer, default: 5
  end
end
