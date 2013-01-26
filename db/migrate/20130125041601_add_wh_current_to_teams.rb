class AddWhCurrentToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :wh_current, :integer
  end
end
