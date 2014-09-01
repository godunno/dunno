require 'spec_helper'

describe CoursePusher do

  let(:course) { create :course }
  let(:event) { create :event, course: course }
  let(:student_pusher_events) { CoursePusherEvents.new(create(:student).user) }
  let(:teacher_pusher_events) { CoursePusherEvents.new(create(:teacher).user) }

  before do
    Pusher.stub(:trigger)
    @course_pusher = CoursePusher.new(event)
  end

  describe "#open" do

    before do
      @course_pusher.open
    end

    it "should have received the correct parameters" do
      expect(Pusher).to have_received(:trigger).with(
        course.channel,
        teacher_pusher_events.open_event,
        @course_pusher.pusher_open_event_json
      )
    end
  end
end
