class SourceSerializer < ActiveModel::Serializer
  attributes :id, :type, :name
  has_many :parameters
end
