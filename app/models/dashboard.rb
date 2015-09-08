class Dashboard < ActiveRecord::Base

  has_many :permissions
  has_many :data_source_servers, :through => :permissions
  has_many :widgets, -> { order :position }

  accepts_nested_attributes_for :permissions, allow_destroy: true
end
