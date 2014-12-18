class Widget < ActiveRecord::Base
  
  belongs_to :widget_type
  belongs_to :dashboard
  belongs_to :indicator
  
end
