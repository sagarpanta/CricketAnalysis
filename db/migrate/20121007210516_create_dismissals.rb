class CreateDismissals < ActiveRecord::Migration
  def change
    create_table :dismissals do |t|
      t.string :dismissaltype

      t.timestamps
    end
  end
end
