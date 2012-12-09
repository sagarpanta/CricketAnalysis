class CreateBattings < ActiveRecord::Migration
  def change
    create_table :battings do |t|
      t.integer :teamkey
      t.integer :tournamentkey
      t.integer :matchkey
      t.integer :battingendkey
      t.integer :batsmankey
      t.integer :bowlerkey
      t.integer :runs
      t.integer :zeros
      t.integer :ones
      t.integer :twos
      t.integer :threes
      t.integer :fours
      t.integer :fives
      t.integer :sixes
      t.integer :other
      t.integer :position
      t.integer :outtypekey
      t.string :fielderkey
      t.string :integer
      t.boolean :outbywk
      t.integer :formatkey
      t.integer :dotconversionkey

      t.timestamps
    end
  end
end
