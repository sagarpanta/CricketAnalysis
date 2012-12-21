class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :matchtypekey
      t.integer :teamidone
      t.integer :teamidtwo
      t.integer :tournamentkey
      t.integer :venuekey
      t.integer :matchwon
      t.integer :matchtied
      t.boolean :matchwonortied
      t.integer :winnerkey
      t.string :details
      t.integer :formatkey
	  t.integer :tosswon
	  t.integer :clientkey
	  t.float :matchovers
	  t.date :matchdate
      t.integer :dayandnite
	  t.string :electedto
	  t.string :pitchcondition

      t.timestamps
    end
	
	add_index(:matches, [:id, :clientkey, :matchdate, :matchtypekey, :pitchcondition, :electedto], {:unique=>true, :name=> 'UIX_Matches_idNmatchtype'})
	add_index(:matches, [:id, :clientkey, :teamidone, :teamidtwo, :winnerkey], {:unique=>true, :name=> 'UIX_Matches_idNteam'})
	
  end
end
