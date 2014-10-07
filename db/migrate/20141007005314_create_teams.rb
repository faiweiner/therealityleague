class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
    	t.string :name
    	t.integer :season_id
    	t.integer :contestant_id
    end
  end
end
