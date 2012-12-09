
class AddTypesToMatchtypes < ActiveRecord::Migration
	TYPES = [
			{:matchtype => 'Practice'},
			{:matchtype => 'Tournament'}
	]
	def change
		TYPES.each do |type|
			MatchType.create!(type)
		end
	end
end
