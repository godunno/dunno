class TimelineUserMessageSerializer < ActiveModel::Serializer
  attributes :id, :content, :student, :created_at, :updated_at

end
