class ExecutionSerializer < ActiveModel::Serializer
  attributes :id, :order
  has_one :function
  has_many :parameters
end
