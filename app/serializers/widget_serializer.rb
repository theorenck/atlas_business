class WidgetSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :color, :position, :size
  has_one :indicator
  has_one :widget_type
end
