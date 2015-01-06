class Execution < ActiveRecord::Base
  
  has_many :parameters, as: :parameterizable, class_name: "ValuedParameter"
  
  belongs_to :aggregation
  belongs_to :function
end
