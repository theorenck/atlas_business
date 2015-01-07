class TypedParameter < Parameter
  validates :datatype, presence: true
end
