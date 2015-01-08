class Aggregation < Source
    
  has_many :executions

  has_many :aggregated_sources

  has_many :sources, :through => :aggregated_sources, :source => :source

  accepts_nested_attributes_for :aggregated_sources, :executions, allow_destroy: true 
end
