class AddDirectionNspellToScorecards < ActiveRecord::Migration
  def change
	add_column :scorecards, :direction, :string
	add_column :scorecards, :spell, :integer
  end
end
