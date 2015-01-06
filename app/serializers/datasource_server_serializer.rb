class DatasourceServerSerializer < ActiveModel::Serializer
  attributes :id, :url, :name, :description
end
