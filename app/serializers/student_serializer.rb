class StudentSerializer < ActiveModel::Serializer
  attributes :name, :email, :avatar

  has_one :organization
end
