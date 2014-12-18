class Query < ActiveRecord::Base
    
  has_one :indicator
  has_many :parameters
  accepts_nested_attributes_for :parameters

end
