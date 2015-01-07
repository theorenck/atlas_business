class PermissionSerializer < ActiveModel::Serializer
  attributes :id
  has_one :dashboard, :data_source_server, :user
end
