require 'spec_helper'

describe AngularHelper do
  let(:course) { create(:course) }
  let(:event) { create(:event, course: course) }
  let(:comment) { create(:comment, event: event) }

  it do
    expect(helper.angular_course_path(course))
      .to eq "/dashboard#/courses/#{course.uuid}/events"
  end

  it do
    params = { startAt: event.start_at.utc.iso8601 }
    expect(helper.angular_event_path(event))
      .to eq "/dashboard#/courses/#{course.uuid}/events?#{ params.to_param }"
  end

  it do
    params = { startAt: event.start_at.utc.iso8601, commentId: comment.id }
    expect(helper.angular_comment_path(comment))
      .to eq "/dashboard#/courses/#{course.uuid}/events?#{ params.to_param }"
  end
end
