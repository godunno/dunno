class StudentSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :authentication_token, :avatar

  has_one :organization
end
