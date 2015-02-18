class CreateJoinTableSchemesShows < ActiveRecord::Migration
  def change
 		create_join_table :schemes, :shows, id: false do |t|
			t.integer :scheme_id
			t.integer :show_id
		end 
  end
end
