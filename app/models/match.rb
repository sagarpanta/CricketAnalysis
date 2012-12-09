class Match < ActiveRecord::Base
  attr_accessible :clientkey, :details, :matchtied, :matchtypekey, :tosswon, :matchwon, :matchwonortied, :teamidone, :teamidtwo, :tournamentkey, :venuekey, :winnerkey, :formatkey, :matchovers, :dayandnite, :matchdate, :electedto
  
  def matchwonortied=(matchwonortied)
	write_attribute(:matchwonortied, matchwonortied)
	if matchwonortied == "1"
		self.matchwon = 1
		self.matchtied = 0
	elsif matchwonortied != "1" and matchwonortied != "-2"
		self.matchwon = 0
		self.matchtied = 1
	elsif matchwonortied == "-2"
		self.matchwon = 0
		self.matchtied = 0
	end
  end
  
  
  def getMatchType
	return MatchType.find_by_id(self.matchtypekey).matchtype
  end
  
  def getTeamOne(clientkey)
	teamname =  Team.where('clientkey = ? and teamid = ?', clientkey, self.teamidone).select(' distinct teamname as teamname')
	return teamname[0].teamname
  end
  
  def getTeamTwo(clientkey)
	teamname =  Team.where('clientkey = ? and teamid = ?', clientkey, self.teamidtwo).select(' distinct teamname as teamname')
	return teamname[0].teamname
  end
  
  def getTournament
	return Tournament.find_by_id(self.tournamentkey).name
  end
  
  def getVenue
	return Venue.find_by_id(self.venuekey).venuename
  end
  
  def getWinner(clienkey)
	if self.winnerkey == -2 
		teamname = 'N/A'
	else
		teamname =  Team.where('clientkey = ? and teamid = ?', clientkey, self.winnerkey).select(' distinct teamname as teamname')[0].teamname
	end
	return teamname
  end
  
  def getFormat
	return Format.find_by_id(self.formatkey).name
  end
  
  def self.getChartData(chartdata)
	if chartdata.empty?
		return [['']]
	end
	if chartdata[0].attributes.keys.length > 2
		_data = [['Over']]
		groups = []
		columns = []
		chartdata.each do |d|
			if !groups.include? [d.over]
				groups << [d.over]
			end
		end

		chartdata.each do |d|
			if !columns.include? d.inning
				columns << d.inning
			end
		end
		
	
		columns.each do |c|
			_data[0] << c.to_s 		
		end
		
		
		for g in groups
			
			_data << Match.getData(chartdata, g[0], columns)
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
		if d.over == group
			filteredData <<d
		end
	end
	i = 0
	filteredData.each do |f|
		if columns.include? f.inning 
			pos = columns.index(f.inning)
			_data[pos+1]  = f.runs.to_f
		end
	end
	_data[0] = _data[0].to_s
	return _data
  end
  
  
  def self.data_stringify(_data)
	_datastr = ''
	for i in 0..._data.length
		for j in 0..._data[i].length
			_datastr = _datastr+ _data[i][j].to_s+','
		end
	end
	return _datastr[0...-1]
  end
  
  
end
