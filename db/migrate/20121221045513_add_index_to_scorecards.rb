class AddIndexToScorecards < ActiveRecord::Migration
  def change
	add_index(:scorecards, [:id, :clientkey, :spell, :direction],  {:unique=>true, :name=> 'UIX_Scorecards_idspellndirection'})
  end
end
