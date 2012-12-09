class CreateBowlings < ActiveRecord::Migration
  def change
    create_table :bowlings do |t|
      t.integer :teamkey
      t.integer :tournamentkey
      t.integer :matchkey
      t.integer :bowlingendkey
      t.integer :batsmankey
      t.integer :bowlerkey
      t.boolean :ballsdelivered
      t.integer :zeros
      t.integer :ones
      t.integer :twos
      t.integer :threes
      t.integer :fours
      t.integer :fives
      t.integer :sixes
      t.integer :other
      t.integer :wides
      t.integer :noballs
      t.integer :legbyes
      t.integer :byes
      t.integer :wicketkeeperkey
      t.integer :wicket
      t.integer :outtypekey
      t.integer :fielderkey
      t.boolean :outbywk
      t.integer :formatkey
      t.integer :position

      t.timestamps
    end
  end
end
