class QuerySerializer < ActiveModel::Serializer
  attributes :type, :statement
  has_many :parameters    
end
