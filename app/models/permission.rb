class Permission < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :dashboard
  belongs_to :api_server
  
  accepts_nested_attributes_for :api_server
end
