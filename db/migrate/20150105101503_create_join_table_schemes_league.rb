class CreateJoinTableSchemesLeague < ActiveRecord::Migration
  def change
    create_join_table :leagues, :schemes, id: false do |t|
    	t.integer :league_id
    	t.integer :scheme_id
    end
  end
end
