class AddMatchoversToMatches < ActiveRecord::Migration
  def change
	add_column :matches, :matchovers, :integer
  end
end
