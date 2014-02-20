class StudentSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :avatar

  has_one :organization
end
