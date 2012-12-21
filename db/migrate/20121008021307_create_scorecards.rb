class CreateScorecards < ActiveRecord::Migration
  def change
    create_table :scorecards do |t|
	  t.integer :clientkey
      #t.integer :ballsbeforeboundary
      #t.integer :ballsbeforerun
      t.integer :ballsdelivered
      t.integer :ballsfaced
      t.integer :batsmankey
      t.integer :battingendkey
      t.integer :battingposition
	  t.integer :currentbowlerkey
      t.integer :bowlerkey
      t.integer :bowlingendkey
      t.integer :bowlingposition
      t.integer :byes
      t.integer :currentstrikerkey
      t.integer :currentnonstrikerkey
      t.integer :eights
      t.integer :fielderkey
      t.integer :fives
      t.integer :formatkey
      t.integer :fours
      t.integer :inning
      t.integer :legbyes
      t.integer :maiden
      t.integer :matchkey
      t.integer :noballs
      t.integer :ones
      t.integer :others
      t.integer :outtypekey
      t.integer :outbywk
      t.integer :runs
      t.integer :sevens
      t.integer :sixes
      t.integer :teamidone
      t.integer :teamtwoid
      t.integer :threes
      t.integer :tournamentkey
      t.integer :twos
      t.integer :venuekey
      t.integer :wicket
      t.integer :wides
      t.integer :zeros
      t.integer :dismissedbatsmankey
	  t.string  :cr
	  t.integer :line
	  t.integer :length
	  t.integer :shottype
	  t.integer :side
	  t.integer :over
	  t.integer :ballnum


      t.timestamps
    end
	add_index(:scorecards, [:id, :clientkey], :unique=>true)
	add_index(:scorecards, [:id, :clientkey, :ballnum, :formatkey, :tournamentkey, :venuekey, :inning, :matchkey, :outtypekey, :batsmankey, :currentnonstrikerkey,:currentbowlerkey, :battingposition, :bowlingposition, :cr , :dismissedbatsmankey ], {:unique=>true, :name=> 'UIX_Scorecards_Evrythng'} ) 
	add_index(:scorecards, [:id, :line, :length, :shottype, spell, direction], {:unique=>true, :name=> 'UIX_Scorecards_LineLenghtShottype'} ) 
  end
end
