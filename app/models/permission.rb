class Permission < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :dashboard
  belongs_to :data_source_server
  
  accepts_nested_attributes_for :data_source_server, allow_destroy: true
end
