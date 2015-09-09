require 'spec_helper'

describe Api::V1::EventsController do

  let(:profile) { create(:profile) }
  let(:course) { create(:course, start_date: 1.month.ago, end_date: 1.month.from_now, teacher: profile) }
  let(:event) { create(:event, course: course) }

  describe "GET /api/v1/events" do
    let(:topic) { create(:topic) }
    let(:personal_topic) { create(:topic, :personal) }
    let(:event) { create(:event, status: 'published', course: course, topics: [topic, personal_topic]) }
    let!(:earlier_event) { create(:event, course: course, start_at: event.start_at - 1.day) }
    let!(:event_from_another_course) { create(:event) }

    def do_action(params = {})
      get "/api/v1/events.json", params.merge(auth_params(profile))
    end

    describe "events within the week" do
      let(:events_json) { json["events"] }
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
        do_action
      end

      subject do
        json["events"].map { |event| event["uuid"] }
      end

      it { expect(last_response.status).to eq(200) }
      it { expect(json["finished"]).to be_nil }
      it { expect(subject).to eq([earlier_event.uuid, event.uuid]) }

      describe "attributes" do
        subject { json["events"][1] }
        it { expect(last_response.status).to eq(200) }
        it do
          expect(subject).to eq(
            "id" => event.id,
            "uuid" => event.uuid,
            "status" => event.status,
            "formatted_status" => event.formatted_status(profile),
            "start_at" => event.start_at.utc.iso8601,
            "end_at" => event.end_at.utc.iso8601,
            "classroom" => nil,
            "topics" => [
              "uuid" => topic.uuid,
              "done" => topic.done,
              "personal" => topic.personal,
              "media_id" => topic.media_id,
              "description" => topic.description
            ],
            "course" =>  {
              "uuid" => course.uuid,
              "name" => course.name,
              "active" => true,
              "start_date" => course.start_date.to_s,
              "end_date" => course.end_date.to_s,
              "abbreviation" => course.abbreviation,
              "grade" => course.grade,
              "class_name" => course.class_name,
              "order" => course.order,
              "access_code" => course.access_code,
              "institution" => course.institution,
              "user_role" => profile.role_in(course),
              "teacher" => { "name" => course.teacher.name },
              "color" => SHARED_CONFIG["v1"]["courses"]["schemes"][course.order],
              "weekly_schedules" => [],
              "students_count" => 0,
              "members_count" => 1,
              "members" => ["name" => profile.name, "role" => "teacher"]
            }
          )
        end
      end
    end

    context "filtering by course", :elasticsearch do
      let!(:another_course) { create(:course, teacher: profile, start_date: '2015-08-01', end_date: nil) }
      let!(:event) { create(:event, course: another_course, status: 'published', start_at: Time.parse('2015-08-06 09:00')) }
      let!(:unpublished_event) { create(:event, course: another_course, status: 'draft', start_at: event.start_at - 1.day) }

      before do
        Timecop.travel Time.zone.parse('2015-08-01 00:00')
        refresh_index!
        do_action(course_id: another_course.uuid)
      end

      subject do
        json["events"].map { |event| event["uuid"] }
      end

      it { is_expected.to eq([event.uuid, unpublished_event.uuid]) }
      it { expect(json["finished"]).to be true }
    end
  end

  describe "GET /api/v1/events/:start_at" do

    before do
      Timecop.freeze Time.zone.local(2015, 1, 2, 9)
      (0..6).each do |weekday|
        create(:weekly_schedule, weekday: weekday, course: course)
      end
    end

    after { Timecop.return }

    context "existing event" do
      let(:topic) { create(:topic) }
      let(:topic_with_url) { create(:topic, media: media_with_url) }
      let(:topic_with_file) { create(:topic, media: media_with_file) }
      let(:personal_topic) { create(:topic, :personal) }
      let(:media_with_url) { build(:media_with_url) }
      let(:media_with_file) { build(:media_with_file) }
      let(:classroom) { "201-A" }
      let(:start_at) { Time.current }
      let!(:event_from_another_course) do
        create(:event,
               created_at: 1.hour.ago,
               status: "published",
               start_at: start_at,
               course: create(:course, teacher: profile)
              )
      end
      let!(:event) do
        create(:event,
               created_at: 1.hour.from_now,
               status: "published",
               start_at: start_at,
               end_at: 1.hour.ago,
               topics: [topic, personal_topic, topic_with_url, topic_with_file],
               course: course,
               classroom: classroom
              )
      end
      let!(:previous_event) { create :event, start_at: event.start_at - 1.day, course: event.course }
      let!(:previous_event_media) { create :media }
      let!(:previous_event_topic) { create :topic, event: previous_event, media: previous_event_media }
      let!(:next_event)     { create :event, start_at: event.start_at + 1.day, course: event.course }
      let!(:next_event_media) { create :media }
      let!(:next_event_topic) { create :topic, event: next_event, media: next_event_media }

      subject { json }
      let(:event_json) { json }

      it { expect(last_response.status).to eq(200) }

      def do_action
        get "/api/v1/events/#{start_at.utc.iso8601}.json", { course_id: course.uuid }.merge(auth_params(profile))
      end

      before(:each) do
        do_action
      end

      describe "event" do
        let(:target) { event }

        subject { event_json }
        it_behaves_like "request return check", %w(uuid status start_at end_at classroom)

        it { expect(last_response.status).to eq(200) }
        it { expect(subject["formatted_status"]).to eq(event.formatted_status(profile)) }

        describe "course" do
          let(:target) { event.course }
          subject { event_json["course"] }
          it_behaves_like "request return check", %w(name class_name order institution)
        end

        describe "previous" do
          let(:target) { previous_event }
          subject { event_json["previous"] }
          it_behaves_like "request return check", %w(uuid status start_at end_at)
          it { expect(subject["formatted_status"]).to eq(previous_event.formatted_status(profile)) }

          describe "topics" do
            before { skip }
            let(:target) { previous_event_topic }
            let(:previous_event_topic_json) { find(event_json["previous"]["topics"], previous_event_topic.uuid) }
            subject { previous_event_topic_json }
            it_behaves_like "request return check", %w(description uuid order done)

            describe "media" do
              let(:target) { previous_event_media }
              subject { previous_event_topic_json["media"] }
              it_behaves_like "request return check", %w(title description url uuid type thumbnail)
            end
          end
        end

        describe "next" do
          let(:target) { next_event }
          subject { event_json["next"] }
          it_behaves_like "request return check", %w(uuid status start_at end_at)
          it { expect(subject["formatted_status"]).to eq(next_event.formatted_status(profile)) }

          describe "topics" do
            before { skip }
            let(:target) { next_event_topic }
            let(:next_event_topic_json) { find(event_json["next"]["topics"], next_event_topic.uuid) }
            subject { next_event_topic_json }
            it_behaves_like "request return check", %w(description uuid order done)

            describe "media" do
              let(:target) { next_event_media }
              subject { next_event_topic_json["media"] }
              it_behaves_like "request return check", %w(title description url uuid type thumbnail)
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
            it_behaves_like "request return check", %w(title description url uuid type thumbnail)
          end
        end
      end
    end

    context "new event" do
      let(:weekly_schedule) { create(:weekly_schedule, weekday: 4, start_time: '14:00', end_time: '16:00', classroom: '203') }
      let(:new_course) { create(:course, start_date: 1.day.ago, end_date: Date.current, teacher: profile, weekly_schedules: [weekly_schedule]) }
      let(:start_at) { Time.zone.parse('2015-01-01 14:00') }
      let(:end_at) { Time.zone.parse('2015-01-01 16:00') }

      def do_action
        get "/api/v1/events/#{start_at.utc.iso8601}.json", { course_id: new_course.uuid }.merge(auth_params(profile))
      end

      before do
        do_action
      end

      it do
        expect(json).to eq(
          "id" => nil,
          "uuid" => nil,
          "status" => "draft",
          "formatted_status" => "empty",
          "start_at" => start_at.utc.iso8601,
          "end_at" => end_at.utc.iso8601,
          "classroom" => weekly_schedule.classroom,
          "course" => {
            "uuid" => new_course.uuid,
            "name" => new_course.name,
            "start_date" => new_course.start_date.to_s,
            "end_date" => new_course.end_date.to_s,
            "abbreviation" => new_course.abbreviation,
            "grade" => new_course.grade,
            "class_name" => new_course.class_name,
            "order" => new_course.order,
            "access_code" => new_course.access_code,
            "institution" => new_course.institution,
            "color" => SHARED_CONFIG["v1"]["courses"]["schemes"][new_course.order],
            "user_role" => "teacher",
            "students_count" => 0,
            "active" => true,
            "teacher" => { "name" => profile.name },
            "weekly_schedules" => [
              "uuid" => weekly_schedule.uuid,
              "weekday" => weekly_schedule.weekday,
              "start_time" => weekly_schedule.start_time,
              "end_time" => weekly_schedule.end_time,
              "classroom" => weekly_schedule.classroom
            ],
            "members_count" => 1,
            "members" => ["name" => profile.name, "role" => "teacher"]
          },
          "topics" => []
        )
      end
    end
  end

  describe "POST /api/v1/events.json" do

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
        post "/api/v1/events.json", auth_params(profile).merge(params_hash).to_json
      end

      context "trying to create an invalid event" do
        before do
          event_template.course = nil
        end

        it { expect { do_action }.to raise_error(Pundit::NotAuthorizedError) }
      end

      skip "trying to create event on another profile's course"

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
            it { expect(subject.url).to eq media_with_url.url }
            it { expect(subject.thumbnail).to eq media_with_url.thumbnail }
          end
        end
      end
    end
  end

  describe "PATCH /api/v1/events/:start_at.json" do
    context "authenticated" do
      def do_action
        patch "/api/v1/events/#{event.start_at.utc.iso8601}.json", { course_id: course.uuid }.merge(auth_params(profile)).merge(params_hash).to_json
      end

      context "successfully updating" do
        context "updating attributes" do
          let(:params_hash) { { event: { status: "published" } } }
          it do
            expect { do_action }
              .to change { event.reload.status }
              .from("draft").to("published")
          end
        end

        context "reordering topics" do
          let!(:first_topic) { create :topic, event: event, order: 2 }
          let!(:last_topic) { create :topic, event: event, order: 1 }

          let(:params_hash) do
            {
              event: {
                topics: [last_topic, first_topic].map do |topic|
                  topic.attributes.slice("uuid")
                end
              }
            }
          end

          it do
            do_action
            extract_uuid = -> (list) { list.map { |item| item["uuid"] } }
            expect(extract_uuid.(json["topics"])).to eq(extract_uuid.([last_topic, first_topic]))
          end
        end
      end

      context "failing to update event" do
        context "reordering someone else's topics" do
          let(:one_topic_from_someone) { create(:topic) }
          let(:other_topic_from_someone) { create(:topic) }
          let(:params_hash) do
            {
              event: {
                topics: [one_topic_from_someone, other_topic_from_someone].map do |topic|
                  topic.attributes.slice("uuid")
                end
              }
            }
          end

          it { expect { do_action }.to raise_error(ActiveRecord::RecordNotFound) }
        end
      end
    end
  end
end
