class AggregatedSourceSerializer < ActiveModel::Serializer
  attributes :id, :source_id, :aggregation_id
end