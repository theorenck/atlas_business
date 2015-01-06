class Source < ActiveRecord::Base
  
  has_many :parameters, as: :parameterizable, class_name: "TypedParameter"#, :reject_if => lambda { |p| p[:name].blank? and p[:value].blank?}
  has_one :indicator
  
end
