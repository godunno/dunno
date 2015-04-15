require 'spec_helper'

describe Api::V1::Teacher::EventsController do

  let(:teacher) { create(:teacher) }
  let(:course) { create(:course, teacher: teacher) }
  let(:event) { create(:event, course: course, status: "draft") }

  describe "GET /api/v1/teacher/events.json" do

    context "authenticated" do

      let!(:course_from_another_teacher) { create(:course, teacher: create(:teacher)) }
      let!(:event_from_another_teacher) { create(:event, course: course_from_another_teacher) }

      let(:events_json) { json }

      def do_action
        get "/api/v1/teacher/events.json", auth_params(teacher)
      end

      describe "events within the week" do
        before do
          Timecop.freeze(1.year.from_now)
          create(:event, start_at: 2.weeks.ago, course: course)
          create(:event, start_at: 2.weeks.from_now, course: course)
          today = Date.current
          @this_week_events = (today.beginning_of_week..today.end_of_week).map do |date|
            date = date.to_time.change(hour: 13)
            create(:event, start_at: date, course: course)
          end
          do_action
        end

        after { Timecop.return }

        subject { events_json.map { |e| e["uuid"] } }

        it { expect(subject).to match_array(@this_week_events.map(&:uuid)) }
      end

      describe "collection" do

        before do
          event.save!
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
    let(:personal_topic) { create(:topic, :personal) }
    let(:media_with_url) { create(:media_with_url) }
    let(:another_media_with_url) { create(:media_with_url) }
    let(:classroom) { "201-A" }

    let!(:event) do
      create(:event,
             status: "published",
             end_at: 1.hour.ago,
             topics: [topic, personal_topic],
             classroom: classroom
            )
    end
    let!(:previous_event) { create :event, start_at: event.start_at - 1.day, course: event.course }
    let!(:previous_event_media) { create :media }
    let!(:previous_event_topic) { create :topic, event: previous_event, media: previous_event_media }
    let!(:next_event)     { create :event, start_at: event.start_at + 1.day, course: event.course }
    let!(:next_event_media) { create :media }
    let!(:next_event_topic) { create :topic, event: next_event, media: next_event_media }

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
        it_behaves_like "request return check", %w(uuid order status formatted_status start_at end_at)

        it { expect(last_response.status).to eq(200) }
        it { expect(subject["formatted_classroom"]).to eq("#{course.class_name} - #{classroom}") }

        describe "course" do
          let(:target) { event.course }
          subject { event_json["course"] }
          it_behaves_like "request return check", %w(name class_name order institution)
        end

        describe "previous" do
          let(:target) { previous_event }
          subject { event_json["previous"] }
          it_behaves_like "request return check", %w(uuid order status formatted_status start_at end_at)

          describe "topics" do
            before { skip } 
            let(:target) { previous_event_topic }
            let(:previous_event_topic_json) { find(event_json["previous"]["topics"], previous_event_topic.uuid) }
            subject { previous_event_topic_json }
            it_behaves_like "request return check", %w(description uuid order done)

            describe "media" do
              let(:target) { previous_event_media }
              subject { previous_event_topic_json["media"] }
              it_behaves_like "request return check", %w(title description category url uuid type thumbnail)
            end
          end
        end

        describe "next" do
          let(:target) { next_event }
          subject { event_json["next"] }
          it_behaves_like "request return check", %w(uuid order status formatted_status start_at end_at)

          describe "topics" do
            before { skip } 
            let(:target) { next_event_topic }
            let(:next_event_topic_json) { find(event_json["next"]["topics"], next_event_topic.uuid) }
            subject { next_event_topic_json }
            it_behaves_like "request return check", %w(description uuid order done)

            describe "media" do
              let(:target) { next_event_media }
              subject { next_event_topic_json["media"] }
              it_behaves_like "request return check", %w(title description category url uuid type thumbnail)
            end
          end
        end

        describe "topic" do
          before { skip }
          let(:target) { topic }
          let(:topic_json) { find(event_json["topics"], topic.uuid) }
          subject { topic_json }
          it_behaves_like "request return check", %w(description uuid order done personal)

          it { expect(find(event_json["topics"], personal_topic.uuid)).not_to be_nil }

          describe "media with URL" do
            let(:target) { media_with_url }
            subject { topic_json["media"] }
            it_behaves_like "request return check", %w(title description category url uuid type thumbnail)
          end
        end
      end
    end
  end

  describe "POST /api/v1/teacher/events.json" do

    context "authenticated" do

      let(:event_template) { build(:event, course: course) }

      let(:topic) { build :topic, order: 1, done: true, media: media_with_url, personal: true }
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
              media_id: topic.media.uuid,
              personal: topic.personal
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
          it { expect(subject.description).to be_nil }
          it { expect(subject.order).to eq topic.order }
          it { expect(subject).to be_done }
          it { expect(subject).to be_personal }

          describe "media with url" do
            subject { event.topics.first.media }
            it { expect(subject.title).to eq topic.description }
            it { expect(subject.description).to eq media_with_url.description }
            it { expect(subject.category).to eq media_with_url.category }
            it { expect(subject.url).to eq media_with_url.url }
            it { expect(subject.thumbnail).to eq media_with_url.thumbnail }
          end
        end
      end
    end
  end

  describe "PATCH /api/v1/teacher/events/:uuid.json" do

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
