class Parameter < ActiveRecord::Base

  # belongs_to :query
  belongs_to :parameterizable, :polymorphic => true
  belongs_to :function


  validates :name, presence: true
  # self.inheritance_column = nil
  # validates :value, presence: true
  # validates :type, presence: true
  # enum type: [ :varchar, :integer, :decimal, :date, :time, :timestamp]


  
end
