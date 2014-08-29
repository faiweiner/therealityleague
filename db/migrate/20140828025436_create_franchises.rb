class CreateFranchises < ActiveRecord::Migration
  def change
    create_table :franchises do |t|
      t.string :name
    end
  end
end
