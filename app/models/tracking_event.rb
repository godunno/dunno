class TrackingEvent < ActiveRecord::Base
  class NonMemberError < StandardError; end
  enum event_type: %w(course_accessed file_downloaded url_clicked comment_created)

  belongs_to :trackable, polymorphic: true
  belongs_to :course
  belongs_to :profile

  validates :trackable, :course, :profile, presence: true
end
