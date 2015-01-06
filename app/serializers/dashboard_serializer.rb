class DashboardSerializer < ActiveModel::Serializer
  attributes :id, :name, :description 
  has_many :data_source_servers
  has_many :widgets
end
