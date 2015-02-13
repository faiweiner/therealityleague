class CreateUsers < ActiveRecord::Migration
	def change
		create_table :users do |t|
			t.string	:email
			t.string	:username
			t.string	:password_digest
			t.string	:avatar
			t.string	:oauth_token 
			t.datetime :oauth_expires_at
			t.string	:oauth_provider
  	 	t.text		:oauth_id
  		t.integer :timezone
			t.boolean :admin, default: :false
			t.timestamps
			t.datetime :last_logged_in
			t.boolean :verified, default: :fase
		end
	end
end
