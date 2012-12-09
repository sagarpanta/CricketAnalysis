class Tournament < ActiveRecord::Base
  attr_accessible :clientkey, :dateend, :datestart, :formatkey, :name
  
   validates_uniqueness_of  :name, :scope=> [:clientkey]

  def name=(name)
	 write_attribute(:name, name.upcase)
  end  

  def getFormat
	return Format.find_by_id(self.formatkey).name
  end
  
  def getStartDate
	return self.datestart.strftime('%Y-%m-%d')
  end
  
  def getEndDate
	return self.dateend.strftime('%Y-%m-%d')
  end
end
