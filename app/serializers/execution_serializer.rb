class ExecutionSerializer < ActiveModel::Serializer
  attributes :id, :order
  has_many :parameters
  has_one :function
end
