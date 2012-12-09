class AddLengthsToLength < ActiveRecord::Migration
	LENGTHS = [
		{:length => 'Short'},
		{:length => 'Short of Good Length'},
		{:length => 'Good Length'},
		{:length => 'Fuller'},
		{:length => 'Yorker'},
		{:length => 'Full Toss'},
	]
	def change
		LENGTHS.each do |length|
			Length.create!(length)
		end
	end
end
