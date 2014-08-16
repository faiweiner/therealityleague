class CreateJointTable < ActiveRecord::Migration
  def change
    create_table :contestants_rosters do |t|
      t.integer :contestant_id
      t.integer :roster_id
    end
  end
end
