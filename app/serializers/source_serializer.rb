class SourceSerializer < ActiveModel::Serializer
  attributes :id, :type, :code, :name, :description
  has_many :parameters
end
