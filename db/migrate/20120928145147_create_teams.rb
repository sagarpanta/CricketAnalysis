class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
	  t.integer :clientkey
	  t.integer :teamid
	  t.integer :teamtypekey
      t.integer :playerkey
      t.integer :playertypekey
      t.string :teamname
      t.integer :coachkey
      t.integer :managerkey
      t.integer :winloss

      t.timestamps
    end
	add_index(:teams, [:id, :teamid, :clientkey, :playerkey, :coachkey, :managerkey], {:unique=>true, :name=> 'UIX_Teams'})
  end
  
end
