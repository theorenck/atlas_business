class DashboardSerializer < ActiveModel::Serializer
  attributes :id, :name, :description 
  has_many :api_servers
  has_many :widgets
end
