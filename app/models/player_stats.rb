class PlayerStats < ActiveRecord::Base
  attr_accessible :ballsfaced, :battingaverage, :battingstrikerate, :battingstylekey, :bowlingaverage, :bowlingstrikerate, :bowlingstylekey, :bowlingtypekey, :formatkey, :highestscore, :highestwickets, :maidens, :matchesplayed, :maxdismissedbatsmanaskey, :maxdissmissedaskey, :notouts, :playerid, :playerkey, :playertypekey, :positionwbestbattingavg, :positionwbestbattingstrikerate, :stumpings, :totalballsdelivered, :totalcatches, :totalinnings, :totalruns, :totalwickets, :winloss
end
