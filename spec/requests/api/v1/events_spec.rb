require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Events" do
  parameter :user_email, "User's email", required: true
  parameter :user_token, "User's authentication_token", required: true
  let(:user_email) { teacher.email }
  let(:user_token) { teacher.authentication_token }

  let(:json) { JSON.parse(response_body) }
  let!(:teacher) { create(:profile) }
  let!(:weekly_schedule) do
    create :weekly_schedule,
           weekday: 3,
           start_time: '09:00',
           end_time: '11:00'
  end
  let!(:course) do
    create :course,
           teacher: teacher,
           weekly_schedules: [weekly_schedule],
           start_date: '2015-07-01',
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

    let(:course_id) { course.uuid }

    context do
      let(:events_json) { json["events"] }

      let(:previous_month) { Time.zone.parse('2015-07-01 00:00:00').utc.iso8601 }
      let(:current_month) { Time.zone.parse('2015-08-01 00:00:00').utc.iso8601 }
      let(:next_month) { Time.zone.parse('2015-09-01 00:00:00').utc.iso8601 }

      def format_time(time)
        time && time.utc.iso8601
      end

      def event_to_json(event)
        {
          "uuid" => event.uuid,
          "start_at" => format_time(event.start_at),
          "end_at" => format_time(event.end_at),
          "status" => event.status,
          "classroom" => event.classroom
        }
      end

      let!(:published_event) do
        create :event,
               course: course,
               start_at: Time.zone.parse('2015-08-05 09:00'),
               end_at: Time.zone.parse('2015-08-05 11:00'),
               status: 'published'
      end
      let!(:canceled_event) do
        create :event,
               course: course,
               start_at: Time.zone.parse('2015-08-12 09:00'),
               end_at: Time.zone.parse('2015-08-12 11:00'),
               status: 'canceled'
      end
      let!(:draft_event) do
        create :event,
               course: course,
               start_at: Time.zone.parse('2015-08-19 09:00'),
               end_at: Time.zone.parse('2015-08-19 11:00'),
               status: 'draft'
      end
      let!(:non_persisted_event) do
        Event.new(
          start_at: Time.zone.parse('2015-08-26 09:00'),
          end_at: Time.zone.parse('2015-08-26 11:00')
        )
      end

      let(:month_order) do
        [
          published_event,
          canceled_event,
          draft_event,
          non_persisted_event
        ]
      end
      let(:month_order_json) { month_order.map { |event| event_to_json(event) } }

      context "omitting the month" do
        before do
          Timecop.freeze current_month
        end

        example_request "listing events for 08/2015", document: :public do
          expect(events_json).to eq month_order_json
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
          expect(events_json).to eq month_order_json
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
