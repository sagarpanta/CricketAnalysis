class AddClientToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :clientkey, :integer
  end
end
