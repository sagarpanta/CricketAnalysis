class CreateBattingscorecards < ActiveRecord::Migration
  def change
    create_table :battingscorecards do |t|
	  t.integer :clientkey
	  t.string :teamname
      t.string :batsman
      t.integer :batsmankey
      t.integer :position
      t.string :fielder
      t.integer :fielderkey
      t.string :outtype
      t.integer :outtypekey
      t.string :bowler
      t.integer :bowlerkey
      t.integer :runs, :null=>true
      t.integer :ballsfaced
      t.float :strikerate
      t.integer :zeros, :null=>true
      t.integer :ones, :null=>true
      t.integer :twos, :null=>true
      t.integer :threes, :null=>true
      t.integer :fours, :null=>true
      t.integer :fives, :null=>true
      t.integer :sixes, :null=>true
      t.integer :played
      t.integer :matchkey
      t.string :match
      t.integer :tournamentkey
      t.string :tournament
      t.integer :inning
      t.integer :formatkey
      t.string :format
	  t.string :hilite
	  t.string :nonstrikerkey

      t.timestamps
    end
	
	add_index(:battingscorecards, [:id, :clientkey, :batsmankey, :matchkey, :inning], {:unique=>true, :name=> 'UIX_battingcorecards'})
	
  end
end
