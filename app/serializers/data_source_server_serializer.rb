class DataSourceServerSerializer < ActiveModel::Serializer
  attributes :id, :url, :name, :description, :alive
end
