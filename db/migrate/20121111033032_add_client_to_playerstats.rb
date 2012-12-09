class AddClientToPlayerstats < ActiveRecord::Migration
  def change
    add_column :player_stats, :clientkey, :integer
  end
end
