class AddCountryToTeams < ActiveRecord::Migration
  def change
	add_column :teams , :countrykey , :integer
  end
end
