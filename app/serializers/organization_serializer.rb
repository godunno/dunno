class OrganizationSerializer < ActiveModel::Serializer
  attributes :name, :uuid

  has_many :events
end
