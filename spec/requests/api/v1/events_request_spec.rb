require 'spec_helper'

describe Api::V1::EventsController do

  let(:student) { create(:student) }
  let(:course) { create(:course, students: [student]) }
  let(:topic) { create(:topic) }
  let(:topic_with_url) { create(:topic, media: media_with_url) }
  let(:topic_with_file) { create(:topic, media: media_with_file) }
  let(:personal_topic) { create(:topic, :personal) }
  let(:thermometer) { create(:thermometer) }
  let(:poll) { create(:poll, options: [option]) }
  let(:option) { create(:option) }
  let(:media_with_url) { build(:media_with_url) }
  let(:media_with_file) { build(:media_with_file) }
  let(:beacon) { create(:beacon) }
  let!(:event) do
    create(:event, course: course,
                   topics: [topic, personal_topic, topic_with_url, topic_with_file],
                   thermometers: [thermometer],
                   polls: [poll],
                   beacon: beacon
          )
  end
  let(:event_pusher_events) { EventPusherEvents.new(student.user) }

  before do
    [poll, media_with_url, media_with_file].each(&:release!)
  end

  describe "GET /api/v1/events" do

    context "authenticated" do

      let!(:earlier_event) { create(:event, course: course, start_at: event.start_at - 1) }
      let!(:event_from_another_course) { create(:event) }

      before(:each) do
        get "/api/v1/events.json", auth_params(student)
      end

      it { expect(last_response.status).to eq(200) }

      describe "event" do

        let(:target) { event }
        subject { json[1] }
        it_behaves_like "request return check", %w(id uuid channel status start_at end_at)

        it { expect(last_response.status).to eq(200) }

        describe "course" do
          let(:target) { course }
          subject { json[1]["course"] }
          it_behaves_like "request return check", %w(uuid)
        end
      end

      describe "events" do
        subject do
          json.map { |event| event["uuid"] }
        end

        it { expect(json.length).to eq(2) }
        it { expect(subject).to include(event.uuid) }
        it { expect(subject.last).to eq(event.uuid) }
        it { expect(subject).to include(earlier_event.uuid) }
        it { expect(subject.first).to eq(earlier_event.uuid) }
        it { expect(subject).to_not include(event_from_another_course.uuid) }
      end
    end
  end

  describe "GET /api/v1/events/:uuid" do

    context "authenticated" do

      let!(:previous_event) { create :event, start_at: event.start_at - 1.day, course: event.course }
      let!(:next_event)     { create :event, start_at: event.start_at + 1.day, course: event.course }

      def do_action
        get "/api/v1/events/#{event.uuid}.json", auth_params(student)
      end

      before(:each) do
        do_action
      end

      subject { json }

      it { expect(last_response.status).to eq(200) }

      describe "event" do
        let(:event_json) { json }
        let(:target) { event }
        subject { event_json }
        it_behaves_like "request return check", %w(channel)

        describe "previous" do
          let(:target) { event.previous }
          subject { event_json["previous"] }
          it_behaves_like "request return check", %w(uuid)
        end

        describe "next" do
          let(:target) { event.next }
          subject { event_json["next"] }
          it_behaves_like "request return check", %w(uuid)
        end

        describe "topic" do
          let(:target) { topic }
          subject { event_json["topics"][0] }
          it_behaves_like "request return check", %w(description)

          it { expect(find(event_json["topics"], personal_topic.uuid)).to be_nil }
        end

        describe "media with URL" do
          let(:target) { media_with_url }
          subject { find(event_json["topics"], topic_with_url.uuid)["media"] }
          it_behaves_like "request return check", %w(uuid title description category url released_at)
        end

        describe "media with File" do
          let(:target) { media_with_file }
          subject { find(event_json["topics"], topic_with_file.uuid)["media"] }
          it_behaves_like "request return check", %w(uuid title description category released_at)

          it { expect(subject["url"]).to eq target.file.url }
        end
      end
    end
  end
end
