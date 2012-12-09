class AddPlayeridToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :playerid, :integer
  end
end
