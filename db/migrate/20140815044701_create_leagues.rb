class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
    	t.string 		:name
    	t.integer 	:commissioner_id
    	t.integer 	:show_id
    	t.boolean 	:public_access, :default => true
    	t.string		:draft_type
    	t.integer		:storing_system
      t.timestamps
    end
  end
end
