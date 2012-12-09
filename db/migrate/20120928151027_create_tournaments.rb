class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.datetime :datestart
      t.datetime :dateend
      t.integer :formatkey

      t.timestamps
    end
  end
end
