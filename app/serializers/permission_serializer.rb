class PermissionSerializer < ActiveModel::Serializer
  attributes :id
  has_one :dashboard, :api_server, :user
end
