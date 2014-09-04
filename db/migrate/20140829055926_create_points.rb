class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.integer :contestant_id
      t.integer :episode_id
      t.integer :event_id
      t.timestamps
    end
  end
end
