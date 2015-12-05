require 'spec_helper'

describe TrackMediaAccessedEvent do
  let(:course) { create(:course, students: [student]) }
  let(:topic) { create(:topic, event: create(:event, course: course)) }
  let(:media) { create(:media, topics: [topic]) }
  let(:student) { create(:profile) }
  let(:anyone) { create(:profile) }

  def track(profile)
    TrackMediaAccessedEvent.new(media, profile).track
  end

  it "only allows one file_downloaded to be tracked by media" do
    expect { track(student) }.to change { TrackingEvent.count }.by(1)
    expect { track(student) }.not_to change { TrackingEvent.count }
  end

  it "doesn't allow a non-member to track event" do
    expect { track(anyone) }
      .to raise_error(
        TrackingEvent::NonMemberError,
        "Profile#id #{anyone.id} isn't member of any Course#id in [#{course.id}]."
      )
  end

  context "File media" do
    let(:media) { create(:media_with_file, topics: [topic]) }
    let(:tracking_event) { student.tracking_events.last } 

    before { track(student) }

    it { expect(tracking_event.event_type).to eq 'file_downloaded' }
    it { expect(tracking_event.trackable).to eq media }
    it { expect(tracking_event.course).to eq course }
    it { expect(tracking_event.profile).to eq student }
  end

  context "URL media" do
    let(:media) { create(:media_with_url, topics: [topic]) }
    let(:tracking_event) { student.tracking_events.last } 

    before { track(student) }

    it { expect(tracking_event.event_type).to eq 'url_clicked' }
    it { expect(tracking_event.trackable).to eq media }
    it { expect(tracking_event.course).to eq course }
    it { expect(tracking_event.profile).to eq student }
  end

  context "media being used in more than one course" do
    let(:another_course) { create(:course, students: [student]) }
    let(:another_topic) { create(:topic, event: create(:event, course: another_course)) }
    let(:media) { create(:media, topics: [topic, another_topic]) }

    it { expect { track(student) }.to change { TrackingEvent.count }.by(2) }

    it "sets the correct courses for each event" do
      track(student)
      expect(TrackingEvent.last(2).map(&:course)).to match_array [course, another_course]
    end
  end
end
