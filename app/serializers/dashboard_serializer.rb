class DashboardSerializer < ActiveModel::Serializer
  attributes :id, :name, :description 
  has_many :datasource_servers
  has_many :widgets
end
