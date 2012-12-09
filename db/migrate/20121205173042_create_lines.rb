class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.string :line

      t.timestamps
    end
  end
end
