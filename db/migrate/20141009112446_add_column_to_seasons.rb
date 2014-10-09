class AddColumnToSeasons < ActiveRecord::Migration
	def up
		add_column :seasons, :website, :string
		add_column :seasons, :network, :string
	end
end
