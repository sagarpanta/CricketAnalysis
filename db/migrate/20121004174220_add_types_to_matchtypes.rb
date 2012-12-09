
class AddTypesToMatchtypes < ActiveRecord::Migration
	TYPES = [
			{:matchtype => 'Practice'},
			{:matchtype => 'Tournament'}
	]
	def change
		TYPES.each do |type|
			m = MatchType.create(type)
			m.save
		end
	end
end
