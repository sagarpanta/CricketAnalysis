class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :venuename
      t.integer :endonekey
      t.integer :endtwokey
      t.string :endone
      t.string :endtwo

      t.timestamps
    end
  end
end
