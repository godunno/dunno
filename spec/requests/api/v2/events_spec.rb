require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Events" do
  response_field :id, "Event ID"
  response_field :start_at, "ISO8601 representation of the time when the event will start. Includes timezone."
  response_field :end_at, "ISO8601 representation of the time when the event will end. Includes timezone."

  let(:json_response) { JSON.parse(response_body) }
  let(:events_json) { json_response["events"] }

  let(:course) { create(:course) }
  let(:course_id) { course.id }

  get "/api/v2/courses/:course_id/events" do
    parameter :month, "Month desired, if empty the current one."
    parameter :year, "Year desired, if empty the current one."

    response_field :prev, "Link to the previous month calendar."
    response_field :next, "Link to the next month calendar."

    context do
      let!(:event) { create(:event, course: course) }

      let(:year) { Time.zone.now.year }
      let(:month) { Time.zone.now.month }

      example "Listing events", document: :public do
        do_request
        expect(events_json.size).to eq 1
      end

      example_request "sets the right headers and status" do
        expect(response_headers["Content-Type"]).to eq "application/json; charset=utf-8"
        expect(response_status).to eq 200
      end

      example_request "has the previous month link" do
        expect(json_response["prev"]).to eq api_v2_course_events_url(course, month: 1.month.ago.month, year: 1.month.ago.year)
      end

      example_request "has the next month link" do
        expect(json_response["next"]).to eq api_v2_course_events_url(course, month: 1.month.from_now.month, year: 1.month.from_now.year)
      end

      context "an event in the events list" do
        let(:response_event) { events_json.last }

        example_request "has the right attributes" do
          expect(response_event).to eq(
            "id" => event.id,
            "start_at" => event.start_at.iso8601(3),
            "status" => event.formatted_status
          )
        end
      end

      context "requesting for a specific year and month" do
        let!(:event) { create(:event, course: course, start_at: 1.month.ago) }

        let(:now) { Time.zone.now }
        let(:year) { now.year }
        let(:month) { now.month - 1 }

        example_request "shows the right events for the month" do
          expect(events_json.size).to eq 1
        end
      end

    end

    context do
      let!(:event_from_this_month) { create(:event, course: course, start_at: Time.zone.now) }
      let!(:event_from_last_month) { create(:event, course: course, start_at: 1.month.ago) }

      example_request "only shows events from this month" do
        expect(events_json.map { |e| e["id"] })
          .to eq [event_from_this_month.id]
      end
    end
  end
end
