class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
    	t.integer	:user_id
    	t.string :messagetype
    	t.string :messagecomment
    	t.timestamps
    end
  end
end
