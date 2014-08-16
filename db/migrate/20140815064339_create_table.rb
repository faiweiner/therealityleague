class CreateTable < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.string :name
      t.datetime :premiere_date
      t.datetime :draft_close_date
      t.string :country_origin
      t.string :type
      t.timestamps
    end
  end
end
