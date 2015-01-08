class AddResolvedColumnToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :resolved, :boolean, default: false
  end
end
