class AddTeamforToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :teamfor, :date
  end
end
