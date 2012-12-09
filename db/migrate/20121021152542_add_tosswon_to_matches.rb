class AddTosswonToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :tosswon, :integer
  end
end
