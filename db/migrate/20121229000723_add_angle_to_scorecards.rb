class AddAngleToScorecards < ActiveRecord::Migration
  def change
	add_column :scorecards, :angle, :integer
  end
end
