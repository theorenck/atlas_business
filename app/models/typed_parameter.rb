class TypedParameter < Parameter

  has_many :parameters, :as => :parameterizable
  
end
