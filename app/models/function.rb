class Function < ActiveRecord::Base

  has_many :parameters, as: :parameterizable
  has_many :executions

end
