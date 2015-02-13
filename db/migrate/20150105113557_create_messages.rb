class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
    	t.integer	:user_id
    	t.string	:messagetype
    	t.text      :messagecomment
    	t.string	:page_url
    	t.boolean	:resolved, default: :false
    	t.timestamps
    end
  end
end
