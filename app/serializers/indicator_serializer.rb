class IndicatorSerializer < ActiveModel::Serializer
  attributes :id, :name, :description

  has_one :source
  has_one :unity
end
