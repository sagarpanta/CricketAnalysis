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
		{:shottype => 'Late Cut'},
		{:shottype => 'Leave'},
		{:shottype => 'Lofted Over Slip'},
		{:shottype => 'Lofted Square Cut'},
		{:shottype => 'Lofted Square Drive'},
		{:shottype => 'Lofted Cover Drive'},
		{:shottype => 'Lofted Extra Cover Drive'},
		{:shottype => 'Lofted Off Drive'},
		{:shottype => 'Lofted On Drive'},
		{:shottype => 'Lofted Flick'},
		{:shottype => 'Lofted Pull'},
		{:shottype => 'Lofted Straight Drive'},
		{:shottype => 'On Drive'},
		{:shottype => 'Off Drive'},
		{:shottype => 'Paddle Sweep'},
		{:shottype => 'Grounded Pull'},
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
			st=Shottype.create(s)
			st.save
		end
	end
end
