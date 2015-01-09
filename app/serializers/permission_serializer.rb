class PermissionSerializer < ActiveModel::Serializer
  attributes :id, :dashboard_id, :data_source_server_id, :user_id
  # has_one :dashboard, :data_source_server, :user


  def dashboard_id
    object.dashboard_id
  end

  def data_source_server_id
    object.data_source_server_id
  end 

  def user_id
    object.user_id
  end
end
