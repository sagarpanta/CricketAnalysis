class AddMatchdateToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :matchdate, :date
    add_column :matches, :dayandnite, :integer
  end
end
