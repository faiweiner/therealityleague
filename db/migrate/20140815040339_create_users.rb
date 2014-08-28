class CreateUsers < ActiveRecord::Migration
	def change
		create_table :users do |t|
			t.string :email
			t.string :username
			t.string :password_digest
			t.string :avatar
			t.string :oauth_token 
			t.datetime :oauth_expires_at
			t.boolean :admin, default: :false
			t.timestamps
		end
	end
end
