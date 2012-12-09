class AddShottypesToShottype < ActiveRecord::Migration
	SHOTS = [
		{:shottype => 'Backfoot Cover Drive'},
		{:shottype => 'Backfoot Defence'},
		{:shottype => 'Backfoot Glance'},
		{:shottype => 'Backfoot On Drive'},
		{:shottype => 'Backfoot Straight Drive'},
		{:shottype => 'Cover Drive'},
		{:shottype => 'Dancing Down The Wicket'},
		{:shottype => 'Defence'},
		{:shottype => 'Edge'},
		{:shottype => 'Extra Cover Drive'},
		{:shottype => 'Flick'},
		{:shottype => 'Glance'},
		{:shottype => 'Guided Shot'},
		{:shottype => 'Hook'},
		{:shottype => 'Leave'},
		{:shottype => 'On Drive'},
		{:shottype => 'Off Drive'},
		{:shottype => 'Paddle Sweep'},
		{:shottype => 'Pull'},
		{:shottype => 'Reverse Sweep'},
		{:shottype => 'Scoop'},
		{:shottype => 'Slug'},
		{:shottype => 'Square Cut'},
		{:shottype => 'Square Drive'},
		{:shottype => 'Straight Drive'},
		{:shottype => 'Sweep'},
		{:shottype => 'Switch Hit'},
		{:shottype => 'Tap'}
	]
	def change
		SHOTS.each do |s|
			Shottype.create!(s)
		end
	end
end
