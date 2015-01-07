class Aggregation < Source

  has_and_belongs_to_many :sources, 
    class_name: "Query", 
    join_table: :aggregations_sources, 
    foreign_key: :aggregation_id, 
    association_foreign_key: :source_id
    
  has_many :executions
  
end
