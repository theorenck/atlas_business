class AuthenticationSerializer < ActiveModel::Serializer
  attributes :token, :admin
end
