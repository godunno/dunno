require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Courses" do
  let(:json_response) { JSON.parse(response_body) }
  let(:courses_json) { json_response["courses"] }

  get "/api/v2/courses" do
    let!(:user) { create(:user, :teacher_profile, :with_api_key) }
    before { sign_in(user) }
    let!(:course) { create(:course, teacher: user.profile) }
    example "Listing courses", document: :public do
      do_request
      expect(courses_json.size).to eq 1
    end

    example_request "sets the right headers and status" do
      expect(response_headers["Content-Type"]).to eq "application/json; charset=utf-8"
      expect(response_status).to eq 200
    end

    context "a course in the courses list" do
      let(:response_course) { courses_json.last }

      example_request "has the right attributes" do
        expect(response_course).to eq(
          "id" => course.id,
          "name" => course.name,
          "class_name" => course.class_name,
          "start_date" => course.start_date.iso8601,
          "end_date" => course.end_date.iso8601,
          "institution" => course.institution,
          "links" => {
            "href" => "http://www.example.com/api/v2/courses/#{course.id}/events"
          }
        )
      end
    end
  end
end
