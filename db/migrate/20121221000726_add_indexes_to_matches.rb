class AddIndexesToMatches < ActiveRecord::Migration
  def change
	add_index(:matches, [:id, :clientkey, :matchdate, :matchtypekey, :pitchcondition, :electedto], {:unique=>true, :name=> 'UIX_Matches_idNmatchtype'} })
	add_index(:matches, [:id, :clientkey, :teamidone, :teamidtwo, :winnerkey], {:unique=>true, :name=> 'UIX_Matches_idNteam'} })
	add_index(:scorecards, [:id, :clientkey, :spell, :direction],  {:unique=>true, :name=> 'UIX_Scorecards_idspellndirection'} })
  end
end
