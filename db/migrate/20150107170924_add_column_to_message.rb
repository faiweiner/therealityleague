class AddColumnToMessage < ActiveRecord::Migration
  def change
  	add_column :messages, :page_url, :string
  end
end
