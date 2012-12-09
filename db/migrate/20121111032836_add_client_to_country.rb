class AddClientToCountry < ActiveRecord::Migration
  def change
    add_column :countries, :clientkey, :integer
  end
end
