class AddTypesToDismissals < ActiveRecord::Migration
	TYPES = [
			{:dismissaltype => 'bold'},
			{:dismissaltype => 'caught'},
			{:dismissaltype => 'stumped'},
			{:dismissaltype => 'run out'},
			{:dismissaltype => 'handling the ball'},
			{:dismissaltype => 'obstruction of the field'},
			{:dismissaltype => 'retired out'},
			{:dismissaltype => 'lbw'}
	]
	def change
		TYPES.each do |type|
			Dismissal.create!(type)
		end
	end
end
