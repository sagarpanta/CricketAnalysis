class Country < ActiveRecord::Base
  attr_accessible :country, :country_s , :clientkey
  
  validates_uniqueness_of  :country, :country_s, :scope=> [:clientkey]

  
  def country=(country)
	 write_attribute(:country, country.upcase)
  end   

  def country_s=(country_s)
	 write_attribute(:country_s, country_s.upcase)
  end  
end
