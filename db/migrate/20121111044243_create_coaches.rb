class CreateCoaches < ActiveRecord::Migration
  def change
    create_table :coaches do |t|
      t.integer :clientkey
      t.string :name

      t.timestamps
    end
  end
end
