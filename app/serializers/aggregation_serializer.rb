class AggregationSerializer < SourceSerializer
  attributes :result

  has_many :sources
end
