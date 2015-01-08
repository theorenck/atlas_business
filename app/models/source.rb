class Source < ActiveRecord::Base
  
  has_one :indicator
  
  has_many :parameters, as: :parameterizable, class_name: "TypedParameter"
  
  accepts_nested_attributes_for :parameters, 
    allow_destroy: true, :reject_if => lambda { |p| p[:name].blank? }
  
end
