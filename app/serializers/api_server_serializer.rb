class APIServerSerializer < ActiveModel::Serializer
  attributes :id, :url, :name, :description
end
