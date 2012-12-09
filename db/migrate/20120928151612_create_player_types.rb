class CreatePlayerTypes < ActiveRecord::Migration
  def change
    create_table :player_types do |t|
      t.string :type

      t.timestamps
    end
  end
end
