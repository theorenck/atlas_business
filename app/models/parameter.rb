class Parameter < ActiveRecord::Base

  # belongs_to :query
  belongs_to :parameterizable, :polymorphic => true

  validates :name, presence: true

  # validates :value, presence: true
  # validates :type, presence: true
  # enum type: [ :varchar, :integer, :decimal, :date, :time, :timestamp]


  
end
