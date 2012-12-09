class CreateShottypes < ActiveRecord::Migration
  def change
    create_table :shottypes do |t|
      t.string :shottype

      t.timestamps
    end
  end
end
