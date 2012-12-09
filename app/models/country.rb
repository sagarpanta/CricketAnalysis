class Country < ActiveRecord::Base
  attr_accessible :country, :clientkey
  
  validates_uniqueness_of  :country, :scope=> [:clientkey]

  
  def country=(country)
	 write_attribute(:country, country.upcase)
  end   
end
