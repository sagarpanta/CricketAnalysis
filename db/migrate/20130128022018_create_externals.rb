class CreateExternals < ActiveRecord::Migration
  def change
    create_table :externals do |t|
      t.integer :_over
      t.integer :ballnum
      t.string :striker
      t.string :nonstriker
      t.string :bowler
      t.string :fielder
      t.integer :runs
      t.integer :extras
      t.string :balltype
      t.string :shottype
      t.string :line
      t.string :length
      t.string :uncomfortable
      t.string :wicket
      t.string :beaten
      t.string :releaseshot
      t.string :bowlingend
      t.string :bowlingside

      t.timestamps
    end
  end
end
