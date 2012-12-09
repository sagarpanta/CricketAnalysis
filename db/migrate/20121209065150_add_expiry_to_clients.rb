class AddExpiryToClients < ActiveRecord::Migration
  def change
	add_column :clients, :expiry, :date
  end
end
