class CreateRightLefts < ActiveRecord::Migration
  def change
    create_table :right_lefts do |t|
      t.string :rightorleft

      t.timestamps
    end
  end
end
