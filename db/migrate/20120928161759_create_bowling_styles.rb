class CreateBowlingStyles < ActiveRecord::Migration
  def change
    create_table :bowling_styles do |t|
      t.string :style

      t.timestamps
    end
  end
end
