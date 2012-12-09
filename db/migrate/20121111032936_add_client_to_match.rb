class AddClientToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :clientkey, :integer
  end
end
