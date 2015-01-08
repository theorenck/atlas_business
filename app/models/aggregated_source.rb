class AggregatedSource < ActiveRecord::Base
  belongs_to :aggregation, touch: true
  belongs_to :source
end