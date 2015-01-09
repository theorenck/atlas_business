class IndicatorSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :code

  has_one :source
  has_one :unity
end
