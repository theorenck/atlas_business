class AggregationSerializer  < ActiveModel::Serializer
  attributes :id, :type, :code, :name, :description, :result

  has_many :parameters
  has_many :sources
  has_many :executions

end
