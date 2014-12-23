class Parameter < ActiveRecord::Base

  belongs_to :query
  
  validates :name, presence: true
  validates :default_value, presence: true
end
