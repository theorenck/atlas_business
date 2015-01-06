class SourceSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :parameters
end
