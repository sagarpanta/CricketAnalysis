class Player < ActiveRecord::Base
  attr_accessible :clientkey, :countrykey, :age, :battingstyle, :bowlingstyle, :bowlingtype, :dob, :fname, :format, :formatkey, :fullname, :lname, :playerid, :playertype, :wh_current

  
    validates_uniqueness_of  :playerid, :scope=> [:clientkey]
  
  def battingstyle=(battingstyle)
	 write_attribute(:battingstyle, battingstyle)
	 self.fullname = self.fname.capitalize+ ' '+self.lname.capitalize
	 #self.battingstyle = RightLeft.where('id = ?', battingstylekey)[0].rightorleft
	 self.wh_current = 1
  end 
  
  def bowlingstyle=(bowlingstyle)
	 write_attribute(:bowlingstyle, bowlingstyle)
	 #self.bowlingstyle = RightLeft.where('id = ?', bowlingstylekey)[0].rightorleft
	 self.wh_current = 1
  end 
  
  def bowlingtype=(bowlingtype)
	 write_attribute(:bowlingtype, bowlingtype)
	 #self.bowlingtype = BowlingStyle.where('id = ?', bowlingtypekey)[0].style
	 self.wh_current = 1
  end 
  
  def playertype=(playertype)
	 write_attribute(:playertype, playertype)
	 #self.bowlingtype = BowlingStyle.where('id = ?', bowlingtypekey)[0].style
	 self.wh_current = 1
  end 
  
  
  def dob=(dob)
  	dob = DateTime.parse(dob)
	dob = dob.strftime("%d/%m/%Y")
	dob = Time.parse(dob)
	write_attribute(:dob, dob)
	self.age = (Time.now - dob)/3600/24/365
  end
  
  
  def formatkey=(formatkey)
	write_attribute(:formatkey, formatkey)
	self.format = Format.where('id=?', formatkey)[0].name
  end
  
  def getCountry(playerkey)
	countrykey = Player.where('id=?', playerkey)[0].countrykey
	name = Country.where('id = ?', countrykey)[0].country
	return name
  
  end
  


	def self.maxplayerid
	    max_id = Player.maximum(:playerid).nil? ? 1 : Player.maximum(:playerid)+1
		return max_id
	
	end
  
  
end

