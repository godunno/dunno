require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Courses" do
  parameter :user_email, "User's email", required: true
  parameter :user_token, "User's authentication_token", required: true
  let(:user_email) { teacher.email }
  let(:user_token) { teacher.authentication_token }

  let(:json) { JSON.parse(response_body).deep_symbolize_keys }
  let(:teacher) { create(:profile) }
  let(:student) { create(:profile) }
  let!(:course) { create(:course, teacher: teacher, students: [student]) }

  patch "/api/v1/courses/:id/block.json" do
    parameter :student_id, "Student's id", required: true, scope: :course

    let(:id) { course.uuid }
    let(:raw_post) { params.to_json }

    context "successfully blocking student" do
      let(:student_id) { student.id }

      example_request "should have blocked student" do
        expect(student.reload.blocked_in?(course)).to be true
      end

      example "generates a SystemNotification for the student" do
        deliverer = double("BlockedNotification", deliver: nil)
        expect(BlockedNotification)
          .to receive(:new).with(course, student).and_return(deliverer)

        do_request

        expect(deliverer).to have_received(:deliver)
      end
    end

    context "trying to block himself" do
      let(:student_id) { teacher.id }

      example_request "should not be able to block" do
        expect(json).to eq(
          errors: {
            role: [error: "is_teacher"]
          }
        )
      end

      example "doesn't generate a SystemNotification" do
        expect(BlockedNotification).not_to receive(:new)
        do_request
      end
    end

    context "trying to block someone who's not in the course" do
      let(:other_profile) { create(:profile) }
      let(:student_id) { other_profile.id }

      example "should not be able to block" do
        expect(BlockedNotification).not_to receive(:new)
        expect { do_request }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  patch "/api/v1/courses/:id/unblock.json" do
    parameter :student_id, "Student's id", required: true, scope: :course

    let(:id) { course.uuid }
    let(:raw_post) { params.to_json }

    before do
      student.block_in!(course)
    end

    context "successfully unblocking student" do
      let(:student_id) { student.id }

      example_request "should have unblocked student" do
        expect(student.reload.blocked_in?(course)).to be false
      end
    end

    context "trying to unblock himself" do
      let(:student_id) { teacher.id }

      example_request "should not be able to unblock" do
        expect(json).to eq(
          errors: {
            role: [error: "is_teacher"]
          }
        )
      end
    end

    context "trying to unblock someone who's not in the course" do
      let(:student_id) { create(:profile).id }

      example "should not be able to unblock" do
        expect { do_request }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  get "/api/v1/courses/:id/analytics.json" do
    let(:json) { JSON.parse(response_body) }

    parameter :since, "Time since when to count the tracking events"

    before do
      Timecop.freeze Time.zone.parse('2015-12-31 09:30')
    end

    after { Timecop.return }

    let(:id) { course.uuid }

    let!(:course_accessed_event) do
      create :tracking_event, :course_accessed,
             course: course,
             profile: student
    end
    let!(:file_downloaded_event) do
      create :tracking_event, :file_downloaded,
             course: course,
             profile: student
    end
    let!(:url_clicked_event) do
      create :tracking_event, :url_clicked,
             course: course,
             profile: student
    end
    let!(:comment_created_event) do
      create :tracking_event, :comment_created,
             course: course,
             profile: student
    end
    let!(:tracking_event_from_another_course) do
      create :tracking_event, :course_accessed,
             course: create(:course),
             profile: student
    end
    let!(:old_course_accessed_event) do
      create :tracking_event, :course_accessed,
             course: course,
             profile: student,
             created_at: 25.hours.ago
    end

    example_request "returns members with the tracking events counts for the last 24h" do
      expect(json).to eq([
        {
          "id" => student.id,
          "name" => student.name,
          "avatar_url" => student.avatar_url,
          "course_accessed_events" => 1,
          "file_downloaded_events" => 1,
          "url_clicked_events" => 1,
          "comment_created_events" => 1
        },
      ])
    end

    context "passing a time for when to start counting" do
      let(:since) { '2015-12-29T09:30:00-02:00' }

      example_request "returns members with the tracking events counts since the passed time" do
      expect(json).to eq([
        {
          "id" => student.id,
          "name" => student.name,
          "avatar_url" => student.avatar_url,
          "course_accessed_events" => 2,
          "file_downloaded_events" => 1,
          "url_clicked_events" => 1,
          "comment_created_events" => 1
        },
      ])
      end
    end
  end
end
