class AddTempPasswordToClients < ActiveRecord::Migration
  def change
    add_column :clients, :temppass, :string
  end
end
