class WidgetSerializer < ActiveModel::Serializer
  attributes :id, :color, :position, :size
  has_one :indicator
  has_one :widget_type
end
