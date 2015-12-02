require 'spec_helper'

describe TrackCommentCreatedEvent do
  let(:course) { create(:course, students: [student]) }
  let(:comment) do
    create :comment,
           profile: student,
           event: create(:event, course: course)
  end
  let(:student) { create(:profile) }
  let(:anyone) { create(:profile) }

  def track(profile)
    TrackCommentCreatedEvent.new(comment, profile).track
  end

  it "only allows one comment_created to be tracked by comment" do
    expect { track(student) }.to change { TrackingEvent.count }.by(1)
    expect { track(student) }.not_to change { TrackingEvent.count }
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

    it { expect(tracking_event.event_type).to eq 'comment_created' }
    it { expect(tracking_event.trackable).to eq comment }
    it { expect(tracking_event.course).to eq course }
    it { expect(tracking_event.profile).to eq student }
  end
end
