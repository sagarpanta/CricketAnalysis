class AddTypesToTeamType < ActiveRecord::Migration
	TYPES = [
		{:teamtype => 'International'},
		{:teamtype => 'Local'}
	]
	def change
		TYPES.each do |type|
			tt = TeamType.create(type)
			tt.save
		end
	end
end
