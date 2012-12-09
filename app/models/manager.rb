class Manager < ActiveRecord::Base
  attr_accessible :name, :clientkey
  
  validates_uniqueness_of  :name, :scope=> [:clientkey]

  def name=(name)
	 write_attribute(:name, name.upcase)
  end     
end
