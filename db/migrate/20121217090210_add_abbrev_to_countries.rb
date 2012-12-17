class AddAbbrevToCountries < ActiveRecord::Migration
  def change
	add_column :countries, :country_s ,:string
  end
end
