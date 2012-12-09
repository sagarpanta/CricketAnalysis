class AddCountryToPlayers < ActiveRecord::Migration
  def change
	add_column :players , :countrykey , :integer
  end
end
