require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Events" do
  parameter :user_email, "User's email", required: true
  parameter :user_token, "User's authentication_token", required: true
  let(:user_email) { teacher.email }
  let(:user_token) { teacher.authentication_token }

  let(:json) { JSON.parse(response_body) }
  let!(:teacher) { create(:profile) }
  let!(:course) do
    create :course, :with_events,
           teacher: teacher,
           start_date: '2015-08-05',
           end_date: '2015-09-31'
  end

  # Events in August:
  # * 2015-08-05 09:00
  # * 2015-08-12 09:00
  # * 2015-08-19 09:00
  # * 2015-08-26 09:00

  get "/api/v1/events.json" do
    parameter :course_id, "Desired course's uuid.", required: true
    parameter :month, "Desired month, if empty the current one."

    response_field :uuid, "Event's uuid."
    response_field :start_at, "When event starts, in ISO8601 Datetime with TZ."
    response_field :end_at, "When event ends, in ISO8601 Datetime with TZ."
    response_field :status, "Event's status. It can be draft, published or canceled."
    response_field :classroom, "Event's classroom."
    response_field :topics_count, "Event's topics count."

    let(:course_id) { course.uuid }

    context do
      let(:events_json) { json["events"] }

      let(:previous_month) { "2015-07-01T03:00:00Z" }
      let(:current_month) { "2015-08-01T03:00:00Z" }
      let(:next_month) { "2015-09-01T03:00:00Z" }

      let!(:published_event) do
        course.events[0]
      end

      let!(:canceled_event) do
        course.events[1]
      end

      let!(:draft_event) do
        course.events[2]
      end

      let(:non_persisted_event_start_at) { "2015-08-26T12:00:00Z" }
      let(:non_persisted_event_end_at) { "2015-08-26T14:00:00Z" }

      let!(:topic) { create(:topic, event: published_event) }
      let!(:personal_topic) { create(:topic, :personal, event: published_event) }

      let(:expected_events_json) do
        [
          {
            "uuid" => published_event.uuid,
            "start_at" => "2015-08-05T12:00:00Z",
            "end_at" => "2015-08-05T14:00:00Z",
            "status" => published_event.status,
            "classroom" => published_event.classroom,
            "topics" => [
              {
                "uuid" => topic.uuid,
                "done" => topic.done,
                "personal" => false,
                "media_id" => topic.media_id,
                "description" => topic.description
              },
              {
                "uuid" => personal_topic.uuid,
                "done" => personal_topic.done,
                "personal" => true,
                "media_id" => personal_topic.media_id,
                "description" => personal_topic.description
              }
            ]
          },
          {
            "uuid" => canceled_event.uuid,
            "start_at" => "2015-08-12T12:00:00Z",
            "end_at" => "2015-08-12T14:00:00Z",
            "status" => canceled_event.status,
            "classroom" => canceled_event.classroom,
            "topics" => []
          },
          {
            "uuid" => draft_event.uuid,
            "start_at" => "2015-08-19T12:00:00Z",
            "end_at" => "2015-08-19T14:00:00Z",
            "status" => draft_event.status,
            "classroom" => draft_event.classroom,
            "topics" => []
          },
          {
            "uuid" => nil,
            "start_at" => non_persisted_event_start_at,
            "end_at" => non_persisted_event_end_at,
            "status" => 'draft',
            "classroom" => nil,
            "topics" => []
          },
        ]
      end

      context "omitting the month" do
        before do
          Timecop.freeze current_month
        end

        example_request "listing events for 08/2015", document: :public do
          expect(events_json).to eq expected_events_json
        end

        example_request "sets the right headers and status" do
          expect(response_headers["Content-Type"]).to eq "application/json; charset=utf-8"
          expect(response_status).to eq 200
        end

        example_request "has the previous month" do
          expect(json["previous_month"]).to eq previous_month
        end

        example_request "has the previous month" do
          expect(json["current_month"]).to eq current_month
        end

        example_request "has the next month" do
          expect(json["next_month"]).to eq next_month
        end
      end

      context "specifying the month" do
        let(:month) { current_month }

        before do
          Timecop.freeze previous_month
        end

        example_request "Listing events for 08/2015", document: :public do
          expect(events_json).to eq expected_events_json
        end
      end

      context "omitting the course id" do
        let(:course_id) { nil }

        example "requires the course uuid" do
          expect { do_request }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
