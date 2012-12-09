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

      t.timestamps
    end
  end
end
