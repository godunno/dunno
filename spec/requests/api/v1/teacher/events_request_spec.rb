require 'spec_helper'

describe Api::V1::Teacher::EventsController do

  let(:teacher) { create(:teacher) }
  let(:course) { create(:course, teacher: teacher) }
  let(:event) { create(:event, course: course, status: "draft") }

  let(:event_pusher_events) { EventPusherEvents.new(teacher.user) }

  describe "GET /api/v1/teacher/events.json" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      let!(:course_from_another_teacher) { create(:course, teacher: create(:teacher)) }
      let!(:event_from_another_teacher) { create(:event, course: course_from_another_teacher) }

      let(:events_json) { json }

      def do_action
        event.save!
        get "/api/v1/teacher/events.json", auth_params(teacher)
      end

      describe "limit" do
        before do
          10.times { create(:event, course: course) }
          do_action
        end

        subject { events_json }

        it { expect(events_json.count).to eq(9) }
      end

      describe "collection" do

        before do
          do_action
        end

        describe "elements" do
          subject { events_json.map {|event| event["uuid"]} }

          it { expect(subject).to include event.uuid }
          it { expect(subject).not_to include event_from_another_teacher.uuid }
        end

        describe "attributes" do
          subject { events_json[0] }

          it { expect(subject["start_at"]).to eq(event.start_at.utc.iso8601) }

          describe "course" do
            let(:target) { event.course }
            subject { events_json[0]["course"] }
            it_behaves_like "request return check", %w(name class_name order institution)
          end
        end
      end
    end

  end

  describe "GET /api/v1/teacher/events/:uuid.json" do

    let(:topic) { create(:topic, order: 1, done: true, media: media_with_url) }
    let(:media_with_url) { create(:media_with_url) }
    let(:another_media_with_url) { create(:media_with_url) }
    let(:personal_note) { create(:personal_note, order: 1, done: true, media: another_media_with_url) }

    let!(:event) do
      create(:event,
             status: "published",
             end_at: 1.hour.ago,
             topics: [topic],
             personal_notes: [personal_note],
            )
    end
    let!(:previous_event) { create :event, start_at: event.start_at - 1.day, course: event.course }
    let!(:next_event)     { create :event, start_at: event.start_at + 1.day, course: event.course }

    context "authenticated" do

      let(:event_json) { json }

      def do_action
        get "/api/v1/teacher/events/#{event.uuid}.json", auth_params(teacher)
      end

      before(:each) do
        do_action
      end

      it { expect(last_response.status).to eq(200) }

      describe "resource" do

        let(:target) { event }

        subject { event_json }
        it_behaves_like "request return check", %w(uuid channel order status formatted_status start_at end_at)

        it { expect(last_response.status).to eq(200) }

        describe "course" do
          let(:target) { event.course }
          subject { event_json["course"] }
          it_behaves_like "request return check", %w(name class_name order institution)
        end

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

        describe "personal_note" do
          let(:target) { personal_note }
          let(:personal_note_json) { event_json["personal_notes"][0] }
          subject { personal_note_json }
          it_behaves_like "request return check", %w(description uuid order done)

          describe "media with URL" do
            let(:target) { another_media_with_url }
            subject { personal_note_json["media"] }
            it_behaves_like "request return check", %w(title description category url released_at uuid type thumbnail)
          end
        end

        describe "topic" do
          let(:target) { topic }
          let(:topic_json) { find(event_json["topics"], topic.uuid) }
          subject { topic_json }
          it_behaves_like "request return check", %w(description uuid order done)

          describe "media with URL" do
            let(:target) { media_with_url }
            subject { topic_json["media"] }
            it_behaves_like "request return check", %w(title description category url released_at uuid type thumbnail)
          end
        end
      end
    end
  end

  describe "POST /api/v1/teacher/events.json" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      let(:event_template) { build(:event, course: course) }

      let(:topic) { build :topic, order: 1, done: true, media: media_with_url }
      let(:personal_note) { build :personal_note, order: 1, done: true, media: another_media_with_url }
      let(:media_with_url) { create :media_with_url }
      let(:another_media_with_url) { create :media_with_url }
      let(:start_at) { event_template.start_at.utc.iso8601 }
      let(:end_at)   { event_template.end_at.utc.iso8601 }

      let(:params_hash) do
        {
          event: {
            "course_id" => event_template.course_id,
            "start_at" => start_at,
            "end_at"   => end_at,
            topics: [
              description: topic.description,
              done: topic.done,
              order: topic.order,
              media_id: topic.media.uuid
            ],
            personal_notes: [
              description: personal_note.description,
              done: personal_note.done,
              order: personal_note.order,
              media_id: personal_note.media.uuid
            ]
          }
        }
      end

      def do_action
        post "/api/v1/teacher/events.json", auth_params(teacher).merge(params_hash).to_json
      end

      context "trying to create an invalid event" do
        before :each do
          event_template.course = nil
          do_action
        end

        it { expect(last_response.status).to eq(400) }
        it { expect(json['errors']).to have_key('course') }
      end

      skip "trying to create event on another teacher's course"

      context "creating an event" do

        before do
          do_action
        end

        let(:event) { Event.order('created_at desc').first }
        subject { event }

        it { expect(subject.start_at).to eq(event_template.start_at) }
        it { expect(subject.end_at).to eq(event_template.end_at) }

        it { expect(subject.topics.count).to eq 1 }
        describe "topic" do
          subject { event.topics.first }
          it { expect(subject.description).to eq topic.description }
          it { expect(subject.order).to eq topic.order }
          it { expect(subject).to be_done }

          describe "media with url" do
            subject { event.topics.first.media }
            it { expect(subject.title).to eq media_with_url.title }
            it { expect(subject.description).to eq media_with_url.description }
            it { expect(subject.category).to eq media_with_url.category }
            it { expect(subject.url).to eq media_with_url.url }
            it { expect(subject.thumbnail).to eq media_with_url.thumbnail }
          end
        end

        it { expect(subject.personal_notes.count).to eq 1 }
        describe "personal_notes" do
          subject { event.personal_notes.first }
          it { expect(subject.description).to eq personal_note.description }
          it { expect(subject.order).to eq personal_note.order }
          it { expect(subject).to be_done }

          describe "media with url" do
            subject { event.personal_notes.first.media }
            it { expect(subject.title).to eq another_media_with_url.title }
            it { expect(subject.description).to eq another_media_with_url.description }
            it { expect(subject.category).to eq another_media_with_url.category }
            it { expect(subject.url).to eq another_media_with_url.url }
            it { expect(subject.thumbnail).to eq another_media_with_url.thumbnail }
          end
        end
      end
    end
  end

  describe "PATCH /api/v1/teacher/events/:uuid.json" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      skip "invalid event"

      let(:start_at) { event.start_at + 1.hour }
      let(:params_hash) { { event: { start_at: start_at.utc.iso8601, status: "published" } } }

      def do_action
        patch "/api/v1/teacher/events/#{event.uuid}.json", auth_params(teacher).merge(params_hash).to_json
      end

      before do
        event.save!
        do_action
      end

      it { expect(event.reload.start_at).to eq start_at }
      it { expect(event.reload.status).to eq "published" }
    end
  end

  describe "DELETE /api/v1/teacher/events/:uuid.json" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      def do_action
        delete "/api/v1/teacher/events/#{event.uuid}.json", auth_params(teacher).to_json
      end

      before do
        event.save!
      end

      it "should destroy the event" do
        expect do
          do_action
        end.to change(Event, :count).by(-1)
      end
    end
  end
end
