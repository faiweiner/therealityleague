class CreateContestant < ActiveRecord::Migration
  def change
    create_table :contestants do |t|
    	t.string 	:name
    	t.integer :show_id
    	t.integer	:age
    	t.string	:gender
    	t.string	:occupation
    	t.text		:description
    	t.string 	:status_on_show
    	t.boolean :present, :default => true
    end
  end
end
