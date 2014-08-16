class UpdateTableLeagues < ActiveRecord::Migration
  def change
  	rename_column :leagues, :storing_system , :scoring_system
  end
end
