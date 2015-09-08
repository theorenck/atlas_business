class DashboardSerializer < ActiveModel::Serializer

  attributes :id, :name, :description
  has_many :data_source_servers
  has_many :widgets

  def data_source_servers
  	unless options[:authenticated].admin
	  	object.permissions
	  		.select  { |e| e.user == options[:authenticated] }
	  		.collect { |e| e.data_source_server }.uniq
  	else
  		object.data_source_servers.uniq
  	end
	end
end
