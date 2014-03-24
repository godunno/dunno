class CourseSerializer < ActiveModel::Serializer
  attributes :id, :name, :uuid, :start_date, :end_date, :start_time,
    :end_time, :weekdays
  has_one :teacher
end
