class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
	  t.integer :clientkey
      t.integer :age
      t.string :battingstyle
      t.string :bowlingstyle
      t.string :bowlingtype
      t.datetime :dob
      t.string :fname
      t.string :lname
      t.string :format
      t.integer :formatkey
      t.string :fullname
      t.string :playertype
      t.integer :wh_current
      t.integer :playerid

      t.timestamps
    end
	add_index(:players, [:id, :clientkey], :unique=>true)
	add_index(:players, [:id, :clientkey, :battingstyle, :bowlingstyle, :bowlingtype, :playertype, :fullname], {:unique=>true, :name=> 'UIX_Players_Evrything'})
  end
end
