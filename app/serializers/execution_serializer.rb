class ExecutionSerializer < ActiveModel::Serializer
  attributes :id
  has_one :function
  has_many :parameters
end
