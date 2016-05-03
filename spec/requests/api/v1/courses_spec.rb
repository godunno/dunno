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
  let(:course) { create(:course, teacher: teacher, students: [student]) }

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

  patch "/api/v1/courses/:id/promote_to_moderator.json" do
    parameter :student_id, "Student's id", required: true, scope: :course

    let(:id) { course.uuid }
    let(:raw_post) { params.to_json }

    context "successfully promoting student to moderator" do
      let(:student_id) { student.id }

      example_request "should have promoted student" do
        expect(student.reload.moderator_in?(course)).to be true
      end

      example "generates a SystemNotification for the student" do
        deliverer = double("PromotedToModeratorNotification", deliver: nil)
        expect(PromotedToModeratorNotification)
          .to receive(:new).with(course, student).and_return(deliverer)

        do_request

        expect(deliverer).to have_received(:deliver)
      end
    end

    context "trying to promote himself" do
      let(:student_id) { teacher.id }

      example_request "should not be able to promote" do
        expect(json).to eq(
          errors: {
            role: [error: "is_teacher"]
          }
        )
      end

      example "doesn't generate a SystemNotification" do
        expect(PromotedToModeratorNotification).not_to receive(:new)
        do_request
      end
    end

    context "trying to block someone who's not in the course" do
      let(:other_profile) { create(:profile) }
      let(:student_id) { other_profile.id }

      example "should not be able to block" do
        expect(PromotedToModeratorNotification).not_to receive(:new)
        expect { do_request }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  patch "/api/v1/courses/:id/downgrade_from_moderator.json" do
    parameter :student_id, "Student's id", required: true, scope: :course

    let(:id) { course.uuid }
    let(:raw_post) { params.to_json }

    before do
      student.promote_to_moderator_in!(course)
    end

    context "successfully downgrading student from moderator" do
      let(:student_id) { student.id }

      example_request "should have downgraded student" do
        expect(student.reload.moderator_in?(course)).to be false
      end
    end

    context "trying to downgrade himself" do
      let(:student_id) { teacher.id }

      example_request "should not be able to downgrade" do
        expect(json).to eq(
          errors: {
            role: [error: "is_teacher"]
          }
        )
      end
    end

    context "trying to downgrade someone who's not in the course" do
      let(:student_id) { create(:profile).id }

      example "should not be able to downgrade" do
        expect { do_request }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  get "/api/v1/courses/:id/analytics.json" do
    let(:json) { JSON.parse(response_body) }

    parameter :since, "Time since when to count the tracking events"

    before do
      course.add_student(student_without_events)
      Timecop.freeze Time.zone.parse('2015-12-31 09:30')
    end

    after { Timecop.return }

    let(:id) { course.uuid }

    let(:student_without_events) { create(:profile) }
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
        {
          "id" => student_without_events.id,
          "name" => student_without_events.name,
          "avatar_url" => student_without_events.avatar_url,
          "course_accessed_events" => 0,
          "file_downloaded_events" => 0,
          "url_clicked_events" => 0,
          "comment_created_events" => 0
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
          {
            "id" => student_without_events.id,
            "name" => student_without_events.name,
            "avatar_url" => student_without_events.avatar_url,
            "course_accessed_events" => 0,
            "file_downloaded_events" => 0,
            "url_clicked_events" => 0,
            "comment_created_events" => 0
          },
        ])
      end
    end
  end

  post "/api/v1/courses/:id/clone.json" do
    parameter :start_date, "Cloned course's start date"
    parameter :end_date, "[Optional] Cloned course's end date"
    parameter :name, "[Optional] Cloned course's new name"

    let(:user_email) { profile.email }
    let(:user_token) { profile.authentication_token }
    let(:profile) { create(:profile) }

    let(:id) { template.uuid }
    let(:template) { create(:course, :with_events) }
    let(:start_date) { Date.tomorrow.to_s }
    let(:end_date) { 1.month.from_now.to_date.to_s }
    let(:name) { "New course name" }

    let(:raw_post) { params.to_json }

    let(:course) { Course.last }
    let(:weekly_schedule) { WeeklySchedule.order(created_at: :desc).first }
    let(:aws_credentials) do
      double "AwsCredentials",
        access_key: 'access_key',
        signature: 'signature',
        encoded_policy: 'encoded_policy',
        base_url: 'base_url'
    end

    before do
      allow(AwsCredentials).to receive(:new).and_return(aws_credentials)
    end

    example "creates a new course using the referred as a template" do
      allow(CreateCourseFromTemplate).to receive(:new).and_call_original

      expect { do_request }.to change { profile.courses.count }.by(1)
      expect(CreateCourseFromTemplate)
        .to have_received(:new)
        .with(
          template,
          teacher: profile,
          name: name,
          weekly_schedules: [weekly_schedule],
          start_date: start_date,
          end_date: end_date
        )
    end

    example_request "returns the new course" do
      expect(json).to eq(
        course: {
          uuid: course.uuid,
          name: course.name,
          active: true,
          premium: course.premium,
          file_size_limit: course.file_size_limit,
          start_date: course.start_date.to_s,
          end_date: course.end_date.to_s,
          abbreviation: course.abbreviation,
          grade: course.grade,
          class_name: course.class_name,
          order: course.order,
          access_code: course.access_code,
          institution: course.institution,
          color: SHARED_CONFIG["v1"]["courses"]["schemes"][course.order],
          user_role: "teacher",
          students_count: course.students.count,
          teacher: {
            name: profile.name,
            avatar_url: nil
          },
          weekly_schedules: [
            uuid: weekly_schedule.uuid,
            weekday: weekly_schedule.weekday,
            start_time: weekly_schedule.start_time,
            end_time: weekly_schedule.end_time,
            classroom: weekly_schedule.classroom
          ],
          members_count: 1,
          members: [
            id: profile.id,
            name: profile.name,
            role: "teacher",
            avatar_url: nil
          ],
          s3_credentials: {
            access_key: aws_credentials.access_key,
            signature: aws_credentials.signature,
            encoded_policy: aws_credentials.encoded_policy,
            base_url: aws_credentials.base_url
          }
        }
      )
    end
  end
end
