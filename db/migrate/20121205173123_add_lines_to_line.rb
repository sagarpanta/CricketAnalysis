class AddLinesToLine < ActiveRecord::Migration
	LINES = [
		{:line => 'Outside Off'},
		{:line => 'Stumps'},
		{:line => 'Pads'},
		{:line => 'Outside Leg'}
	]
	def change
		LINES.each do |line|
			Line.create!(line)
		end
	end
end
