class ValuedParameter  < Parameter

  has_many :parameters, :as => :parameterizable
  belongs_to :execution

end
