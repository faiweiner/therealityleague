class AddColumnToRounds < ActiveRecord::Migration
  def change
  	add_column :rounds, :user_id, :integer
		add_column :rounds, :league_id, :integer
		remove_column :rounds, :roster_id
  end
end
