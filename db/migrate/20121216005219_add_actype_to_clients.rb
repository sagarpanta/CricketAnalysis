class AddActypeToClients < ActiveRecord::Migration
  def change
	add_column :clients, :actype, :string
  end
end
