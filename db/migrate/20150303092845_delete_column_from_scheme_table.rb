class DeleteColumnFromSchemeTable < ActiveRecord::Migration
  def change
  	remove_column :schemes, :show_id, :integer
  end
end
