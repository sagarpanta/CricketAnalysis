class AddTypesToFormats < ActiveRecord::Migration
	FORMATS = [
			{:name => 'One Day'},
			{:name => '20 - 20'},
			{:name => 'First Class'},
			{:name => 'Test'}
	]
	def change
		FORMATS.each do |f|
			Format.create!(f)
		end
	end
end
