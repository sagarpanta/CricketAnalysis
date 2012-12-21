class AddIndexesToMatches < ActiveRecord::Migration
  def change
	add_index(:matches, [:id, :clientkey, :matchdate, :matchtypekey, :pitchcondition, :electedto], :unique=>true)
	add_index(:matches, [:id, :clientkey, :teamidone, :teamidtwo, :winnerkey], :unique=>true)
	add_index(:scorecards, [:id, :clientkey, :spell, :direction], :unique=>true)
  end
end
