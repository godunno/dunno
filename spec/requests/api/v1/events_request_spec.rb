require 'spec_helper'

describe Api::V1::EventsController do

  let(:profile) { create(:profile) }
  let(:student) { create(:profile) }
  let(:course) do
    create :course,
           start_date: 1.month.ago,
           end_date: 1.month.from_now,
           teacher: profile,
           students: [student]
  end
  let(:event) { create(:event, course: course) }

  describe "GET /api/v1/events/:start_at" do
    before do
      Timecop.freeze Time.zone.local(2015, 1, 2, 9)
      (0..6).each do |weekday|
        create(:weekly_schedule, weekday: weekday, course: course)
      end
    end

    after { Timecop.return }

    context "existing event" do
      let!(:comment) do
        create :comment,
               event: event,
               created_at: 2.hours.ago
      end
      let!(:removed_comment) do
        create :comment, :removed,
               event: event,
               created_at: 1.hour.ago
      end
      let!(:blocked_comment) do
        create :comment, :blocked, event: event
      end
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
      let(:event_start_at) { start_at.utc.iso8601 }

      it { expect(last_response.status).to eq(200) }

      def do_action(current_profile = profile)
        get "/api/v1/events/#{event_start_at}.json",
            { course_id: course.uuid }.merge(auth_params(current_profile))
      end

      before(:each) do
        do_action
      end

      describe "event" do
        let(:target) { event }

        subject { event_json }
        it_behaves_like "request return check", %w(uuid status start_at end_at classroom)

        it { expect(last_response.status).to eq(200) }

        describe "course" do
          let(:target) { event.course }
          subject { event_json["course"] }
          it_behaves_like "request return check", %w(name class_name order institution)
        end

        describe "previous" do
          let(:target) { previous_event }
          subject { event_json["previous"] }
          it_behaves_like "request return check", %w(uuid status start_at end_at)

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

        describe "comments" do
          context "as a teacher" do
            it do
              expect(json["comments"]).to eq [
                {
                  "id" => comment.id,
                  "body" => comment.body,
                  "event_start_at" => event.start_at.iso8601(3),
                  "created_at" => comment.created_at.iso8601(3),
                  "user" => {
                    "name" => comment.profile.name,
                    "avatar_url" => nil,
                    "id" => comment.profile.user.id
                  },
                  "attachments" => [],
                  "removed_at" => nil,
                  "blocked_at" => nil
                },
                {
                  "id" => removed_comment.id,
                  "event_start_at" => event.start_at.iso8601(3),
                  "created_at" => removed_comment.created_at.iso8601(3),
                  "user" => {
                    "name" => removed_comment.profile.name,
                    "avatar_url" => nil,
                    "id" => removed_comment.profile.user.id
                  },
                  "removed_at" => removed_comment.removed_at.iso8601(3),
                  "blocked_at" => nil
                },
                {
                  "id" => blocked_comment.id,
                  "body" => blocked_comment.body,
                  "event_start_at" => event.start_at.iso8601(3),
                  "created_at" => blocked_comment.created_at.iso8601(3),
                  "user" => {
                    "name" => blocked_comment.profile.name,
                    "avatar_url" => nil,
                    "id" => blocked_comment.profile.user.id
                  },
                  "attachments" => [],
                  "removed_at" => nil,
                  "blocked_at" => blocked_comment.blocked_at.iso8601(3)
                }
              ]
            end
          end

          context "as a student" do
            before do
              do_action(student)
            end

            it do
              expect(json["comments"]).to eq [
                {
                  "id" => comment.id,
                  "body" => comment.body,
                  "event_start_at" => event.start_at.iso8601(3),
                  "created_at" => comment.created_at.iso8601(3),
                  "user" => {
                    "name" => comment.profile.name,
                    "avatar_url" => nil,
                    "id" => comment.profile.user.id
                  },
                  "attachments" => [],
                  "removed_at" => nil,
                  "blocked_at" => nil
                },
                {
                  "id" => removed_comment.id,
                  "event_start_at" => event.start_at.iso8601(3),
                  "created_at" => removed_comment.created_at.iso8601(3),
                  "user" => {
                    "name" => removed_comment.profile.name,
                    "avatar_url" => nil,
                    "id" => removed_comment.profile.user.id
                  },
                  "removed_at" => removed_comment.removed_at.iso8601(3),
                  "blocked_at" => nil
                },
                {
                  "id" => blocked_comment.id,
                  "event_start_at" => event.start_at.iso8601(3),
                  "created_at" => blocked_comment.created_at.iso8601(3),
                  "user" => {
                    "name" => blocked_comment.profile.name,
                    "avatar_url" => nil,
                    "id" => blocked_comment.profile.user.id
                  },
                  "removed_at" => nil,
                  "blocked_at" => blocked_comment.blocked_at.iso8601(3)
                }
              ]
            end
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
          "uuid" => nil,
          "status" => "draft",
          "start_at" => start_at.utc.iso8601,
          "end_at" => end_at.utc.iso8601,
          "classroom" => weekly_schedule.classroom,
          "comments" => [],
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
            "teacher" => { "name" => profile.name, "avatar_url" => nil },
            "weekly_schedules" => [
              "uuid" => weekly_schedule.uuid,
              "weekday" => weekly_schedule.weekday,
              "start_time" => weekly_schedule.start_time,
              "end_time" => weekly_schedule.end_time,
              "classroom" => weekly_schedule.classroom
            ],
            "members_count" => 1,
            "members" => [
              "id" => profile.id,
              "name" => profile.name,
              "role" => "teacher",
              "avatar_url" => nil
            ]
          },
          "topics" => []
        )
      end
    end
  end

  describe "POST /api/v1/events.json" do
    context "authenticated" do
      def do_action
        post "/api/v1/events.json", auth_params(profile).merge(params_hash).to_json
      end

      context "trying to create an invalid event" do
        let(:params_hash) do
          {
            event: {
              "course_id" => nil
            }
          }
        end

        it do
          do_action
          expect(last_response.status).to be 403
        end
      end

      skip "trying to create event on another profile's course"

      context "creating an event" do
        let(:media) { create(:media_with_url) }
        let(:start_at) { Time.current.change(usec: 0) }
        let(:end_at)   { 2.hours.from_now.change(usec: 0) }

        let(:params_hash) do
          {
            event: {
              "course_id" => course.id,
              "start_at" => start_at.utc.iso8601,
              "end_at"   => end_at.utc.iso8601,
              topics: [
                description: 'Some description',
                done: true,
                order: 1,
                media_id: media.uuid,
                personal: true
              ]
            }
          }
        end

        before do
          do_action
        end

        let(:event) { course.events.first }
        subject { event }

        it { expect(subject.start_at.change(usec: 0)).to eq(start_at) }
        it { expect(subject.end_at.change(usec: 0)).to eq(end_at) }

        it { expect(subject.topics.count).to eq 1 }
        describe "topic" do
          subject { event.topics.first }
          it { expect(subject.description).to be_nil }
          it { expect(subject.order).to eq 1 }
          it { expect(subject).to be_done }
          it { expect(subject).to be_personal }

          describe "media" do
            subject { event.topics.first.media }
            it { expect(subject.title).to eq "Some description" }
            it { expect(subject.description).to eq media.description }
            it { expect(subject.url).to eq media.url }
            it { expect(subject.thumbnail).to eq media.thumbnail }
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

          it "delivers system notifications for course members" do
            notification = double('EventStatusNotification', deliver: nil)
            allow(EventStatusNotification).to receive(:new).and_return(notification)
            do_action
            expect(EventStatusNotification)
              .to have_received(:new).with(event, profile)
          end

          it "doesn't deliver emails if not canceling event" do
            allow(EventCanceledMailer)
              .to receive(:event_canceled_email)
            do_action
            expect(EventCanceledMailer)
              .not_to have_received(:event_canceled_email)
          end
        end

        context "when canceling event" do
          let(:params_hash) { { event: { status: "canceled" } } }

          it "delivers email to all members" do
            mail = double("mail", deliver: nil)
            expect(EventCanceledMailer)
              .to receive_message_chain(:delay, :event_canceled_email)
            do_action
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
