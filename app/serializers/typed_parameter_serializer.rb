class TypedParameterSerializer < ValuedParameterSerializer
  attributes :datatype, :evaluated

  def attributes
    hash = super
    hash.delete(:evaluated) if hash[:evaluated].nil?
    hash
  end
end
