class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :country
	  t.string :country_s

      t.timestamps
    end
  end
end
