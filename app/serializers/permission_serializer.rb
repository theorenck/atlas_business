class PermissionSerializer < ActiveModel::Serializer
  attributes :id
  has_one :dashboard, :datasource_server, :user
end
