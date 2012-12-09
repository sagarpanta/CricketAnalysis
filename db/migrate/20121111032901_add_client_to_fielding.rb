class AddClientToFielding < ActiveRecord::Migration
  def change
    add_column :fieldings, :clientkey, :integer
  end
end
