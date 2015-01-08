class ExecutionSerializer < ActiveModel::Serializer
  attributes :id, :function

  has_many :parameters

  def function 
    object.function.name
  end
end
