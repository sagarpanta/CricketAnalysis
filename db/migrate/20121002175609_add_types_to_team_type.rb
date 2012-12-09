class AddTypesToTeamType < ActiveRecord::Migration
	TYPES = [
		{:teamtype => 'International'},
		{:teamtype => 'Local'}
	]
	def change
		TYPES.each do |type|
			TeamType.create!(type)
		end
	end
end
