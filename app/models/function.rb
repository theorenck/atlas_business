class Function < ActiveRecord::Base

  has_many :parameters, as: :parameterizable
  
  accepts_nested_attributes_for :parameters
end
