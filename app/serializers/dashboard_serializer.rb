class DashboardSerializer < ActiveModel::Serializer

  attributes :id, :name, :description
  has_many :data_source_servers
  has_many :widgets

  def data_source_servers
  	object.permissions
  		.select  { |e| e.user == options[:authenticated] }
  		.collect { |e| e.data_source_server }
  end
end
