class Indicator < ActiveRecord::Base

	has_many :widgets
  has_many :parameters, :through => :query   

  belongs_to :query

  accepts_nested_attributes_for :query
end
