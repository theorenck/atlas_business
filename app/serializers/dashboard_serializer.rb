class DashboardSerializer < ActiveModel::Serializer

  attributes :id, :name, :description
  has_many :data_source_servers
  has_many :widgets

  def data_source_servers
  	unless option[:authenticated].admin
	  	object.permissions
	  		.select  { |e| e.user == options[:authenticated] }
	  		.collect { |e| e.data_source_server }
  	else
  		object.data_source_servers
  	end
	end
end
