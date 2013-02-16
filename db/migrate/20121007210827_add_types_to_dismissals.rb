class AddTypesToDismissals < ActiveRecord::Migration
	TYPES = [
			{:dismissaltype => 'bowled'},
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
			d = Dismissal.create(type)
			d.save
		end
	end
end
