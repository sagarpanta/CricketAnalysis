class AddVideoLocToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :videoloc, :string
  end
end
