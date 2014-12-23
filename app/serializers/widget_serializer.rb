class WidgetSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :color, :position, :size, :dashboard_id
  has_one :indicator
  has_one :widget_type

  def dashboard_id
    object.dashboard.id
  end
  
end
