class AddFacebookColumnsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :oauth_provider, :string
  	add_column :users, :oauth_id, :text
  	add_column :users, :timezone, :integer
  end
end
