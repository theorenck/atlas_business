class Source < ActiveRecord::Base
  has_one :indicator
  has_many :parameters, as: :parameterizable, class_name: "TypedParameter"
  #, :reject_if => lambda { |p| p[:name].blank? and p[:value].blank?}
  accepts_nested_attributes_for :parameters
end
