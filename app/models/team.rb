
class Team < ActiveRecord::Base
  attr_accessible :clientkey, :coachkey, :managerkey, :playerid, :playerkey, :playertypekey, :teamname, :teamid, :teamtypekey,:winloss, :formatkey, :countrykey, :teamfor

  def playerkey=(playerkey)
	write_attribute(:playerkey, playerkey)
	self.winloss = -2
	self.wh_current = 1
  end
  


	def self.maxteamid(clientkey)
	    max_id = Team.where('clientkey=?',clientkey).maximum(:teamid).nil? ? 1 : Team.where('clientkey=?', clientkey).maximum(:teamid)+1
		return max_id
	end
  
end
