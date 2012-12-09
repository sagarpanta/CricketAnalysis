class AddLinesToLine < ActiveRecord::Migration
	LINES = [
		{:line => 'Outside Off'},
		{:line => 'Stumps'},
		{:line => 'Pads'},
		{:line => 'Outside Leg'}
	]
	def change
		LINES.each do |line|
			l = Line.create(line)
			l.save
		end
	end
end
