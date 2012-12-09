class CreateFieldings < ActiveRecord::Migration
  def change
    create_table :fieldings do |t|
      t.integer :teamkey
      t.integer :tournamentkey
      t.integer :matchkey
      t.integer :venuekey
      t.integer :playerkey
      t.integer :runssaved
      t.integer :catchtaken

      t.timestamps
    end
  end
end
