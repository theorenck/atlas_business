class ExecutionSerializer < ActiveModel::Serializer
  attributes :id, :order, :function_id
  has_many :parameters
end
