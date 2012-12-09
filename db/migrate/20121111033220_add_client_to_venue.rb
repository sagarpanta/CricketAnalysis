class AddClientToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :clientkey, :integer
  end
end
