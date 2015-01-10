class IndicatorSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :code, :unity_id, :source_id

  # has_one :source
  has_one :unity

  def unity_id
    object.unity_id
  end

  def source_id
    object.source_id
  end
end
