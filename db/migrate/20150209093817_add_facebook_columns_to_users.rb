class AddFacebookColumnsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :fb_id, :integer
  	add_column :users, :timezone, :integer
  end
end
