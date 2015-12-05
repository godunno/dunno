require 'spec_helper'

describe TrackEvent::CourseAccessed do
  let(:course) { create(:course, students: [student]) }
  let(:student) { create(:profile) }
  let(:anyone) { create(:profile) }

  def track(profile)
    TrackEvent::CourseAccessed.new(course, profile).track
  end

  it "only allows one course_accessed to be tracked by day" do
    expect { track(student) }.to change { TrackingEvent.count }.by(1)
    expect { track(student) }.not_to change { TrackingEvent.count }
    Timecop.travel 1.day.from_now
    expect { track(student) }.to change { TrackingEvent.count }.by(1)
  end

  it "doesn't allow a non-member to track event" do
    expect { track(anyone) }
      .to raise_error(
        TrackingEvent::NonMemberError,
        "Profile#id #{anyone.id} isn't member of Course#id #{course.id}."
      )
  end

  describe "recent created TrackingEvent" do
    before { track(student) }

    let(:tracking_event) { student.tracking_events.last }

    it { expect(tracking_event.event_type).to eq 'course_accessed' }
    it { expect(tracking_event.trackable).to eq course }
    it { expect(tracking_event.course).to eq course }
    it { expect(tracking_event.profile).to eq student }
  end
end
