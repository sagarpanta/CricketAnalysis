class Venue < ActiveRecord::Base
  attr_accessible :clientkey, :endone, :endonekey, :endtwo, :endtwokey, :venuename
  
   validates_uniqueness_of  :venuename, :scope=> [:clientkey]

  
  def endone=(endone)
	 write_attribute(:endone, endone)
	 self.endonekey = 0
	 self.endtwokey = 1
  end   
  
end
