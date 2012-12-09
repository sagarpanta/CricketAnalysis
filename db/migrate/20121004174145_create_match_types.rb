class CreateMatchTypes < ActiveRecord::Migration
  def change
    create_table :match_types do |t|
      t.string :matchtype

      t.timestamps
    end
  end
end
