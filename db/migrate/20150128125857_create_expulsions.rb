class CreateExpulsions < ActiveRecord::Migration
  def change
    create_table :expulsions do |t|

      t.timestamps
    end
  end
end
