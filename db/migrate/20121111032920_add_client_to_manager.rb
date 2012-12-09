class AddClientToManager < ActiveRecord::Migration
  def change
    add_column :managers, :clientkey, :integer
  end
end
