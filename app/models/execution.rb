class Execution < ActiveRecord::Base
  
  has_many :parameters, as: :parameterizable, class_name: "ValuedParameter"
  
  belongs_to :aggregation
  belongs_to :function

  delegate :name, to: :function

  accepts_nested_attributes_for :parameters
end
