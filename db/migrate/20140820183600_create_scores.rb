class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :round_id
      t.integer :contestant_id
      t.string :event
      t.integer :points

      t.timestamps
    end
  end
end
