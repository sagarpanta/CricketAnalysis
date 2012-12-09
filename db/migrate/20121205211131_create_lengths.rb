class CreateLengths < ActiveRecord::Migration
  def change
    create_table :lengths do |t|
      t.string :length

      t.timestamps
    end
  end
end
