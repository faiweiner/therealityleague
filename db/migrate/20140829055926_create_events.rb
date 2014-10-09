class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :contestant_id
      t.integer :episode_id
      t.integer :scheme_id
      t.integer :points_earned
      t.timestamps
    end
  end
end
