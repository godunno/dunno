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
    end

    context "trying to block someone who's not in the course" do
      let(:student_id) { create(:profile).id }

      example "should not be able to block" do
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
end
