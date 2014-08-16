class CreateRoster < ActiveRecord::Migration
  def change
    create_table :rosters do |t|
      t.integer :user_id
      t.integer :league_id
    end
  end
end
