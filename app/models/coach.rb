class Coach < ActiveRecord::Base
  attr_accessible :clientkey, :name
  
  validates_uniqueness_of  :name, :scope=> [:clientkey]

  
  def name=(name)
	 write_attribute(:name, name.upcase)
  end   
end
