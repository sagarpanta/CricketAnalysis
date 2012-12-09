class Scorecard < ActiveRecord::Base
  attr_accessible :clientkey, :ballsdelivered, :ballsfaced, :batsmanid, :batsmankey, :battingendkey, :battingposition, :bowlerkey, :bowlingendkey, :bowlingposition, :byes, :currentbowlerid, :currentbowlerkey, :currentnonstrikerkey, :currentstrikerkey, :dismissedbatsmankey, :eights, :fielderkey, :fives, :formatkey, :fours, :inning, :legbyes, :maiden, :matchkey, :noballs, :ones, :others, :outbywk, :outtypekey, :runs, :sevens, :sixes, :teamidone, :teamtwoid, :threes, :tournamentkey, :twos, :venuekey, :wicket, :wides, :zeros, :ballnum, :over, :line, :length, :shottype, :side

  
  def self.getChartData(chartdata, group1, group2, metric)
	if chartdata.nil?
		return [['']]
	end
	if chartdata[0].attributes.keys.length > 2
		_data = [[group1.to_s]]
		groups = []
		columns = []
		chartdata.each do |d|
			if !groups.include? [d.grp1]
				groups << [d.grp1]
			end
		end

		chartdata.each do |d|
			if !columns.include? d.grp2
				columns << d.grp2
			end
		end
		
	
		columns.each do |c|
			_data[0] << c.to_s 		
		end
		
		for g in groups
			
			_data << Scorecard.getData(chartdata, g[0], columns)
		end
	else
		_data = [[group1.to_s, metric]]
		chartdata.each do |d|
			_data << [d.grp1.to_s, d.val.to_f]
		end
	end
	return _data
		
  end
  
  
  def self.getData(chartdata, group, columns)
	_data = [group]
	for l in (1..columns.length)
		_data << 0
	end
	filteredData = []
	chartdata.each do |d|
		if d.grp1 == group
			filteredData <<d
		end
	end
	i = 0
	filteredData.each do |f|
		if columns.include? f.grp2 
			pos = columns.index(f.grp2)
			_data[pos+1]  = f.val.to_f
		end
	end
	_data[0] = _data[0].to_s
	return _data
  end
  
  
  
 
  def self.getChartWonLost(chartdata)
	if chartdata.nil?
		return [['']]
	else

		_data = [['Against', 'Won', 'Lost']]
		chartdata.each do |d|
			_data << [d.grp2.to_s, d.won.to_i, d.lost.to_i]
		end
		return _data
	end
	
		
  end
  
      
  
end
