class AddPlayeridToScorecard < ActiveRecord::Migration
  def change
    add_column :scorecards, :batsmanid, :integer
	add_column :scorecards, :currentbowlerid, :integer
  end
end
