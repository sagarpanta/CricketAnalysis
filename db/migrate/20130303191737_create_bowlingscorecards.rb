class CreateBowlingscorecards < ActiveRecord::Migration
  def change
    create_table :bowlingscorecards do |t|
	  t.integer :clientkey
	  t.string :teamname
      t.string :bowler
      t.integer :bowlerkey
      t.integer :position
      t.float :overs, :null=>true
      t.integer :runs, :null=>true
      t.integer :maidens, :null=>true
      t.integer :wickets, :null=>true
      t.float :economy, :null=>true
      t.integer :zeros, :null=>true
      t.integer :ones, :null=>true
      t.integer :twos, :null=>true
      t.integer :threes, :null=>true
      t.integer :fours, :null=>true
      t.integer :fives, :null=>true
      t.integer :sixes, :null=>true
      t.integer :wides, :null=>true
      t.integer :noballs, :null=>true
	  t.integer :byes
	  t.integer :legbyes
	  t.integer :last_run
      t.integer :bowled
      t.integer :matchkey
      t.string :match
      t.integer :tournamentkey
      t.string :tournament
      t.integer :inning
      t.integer :formatkey
      t.string :format
	  t.string :hilite
	  t.float :totalovers
	  t.integer :wicketsgone

      t.timestamps
    end
	add_index(:bowlingscorecards, [:id, :clientkey, :bowlerkey, :matchkey, :inning], {:unique=>true, :name=> 'UIX_bowlingscorecards'})
  end
end
