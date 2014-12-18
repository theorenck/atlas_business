 class IndicatorSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :unity

  has_one :query
end
