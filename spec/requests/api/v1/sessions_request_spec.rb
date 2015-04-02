require 'spec_helper'

describe Api::V1::SessionsController do
  let(:password) { '12345678' }
  let(:course) { create(:course) }
  let!(:student) { create(:student, user: create(:user, password: password), courses: [course]) }
  let!(:teacher) { create(:teacher, user: create(:user, password: password, completed_tutorial: true)) }

  describe "student" do
    describe "POST /api/v1/users/sign_in" do

      context "correct authentication" do

        before(:each) do
          post "/api/v1/users/sign_in", { user: { email: student.email, password: password } }.to_json
        end

        it { expect(last_response.status).to eq(200) }
        it { expect(controller.current_user).to eq(student.user) }

        it do
          expect(json).to eq(
            "root_path" => "/dashboard/student",
            "id" => student.user.id,
            "name" => student.name,
            "phone_number" => student.phone_number,
            "email" => student.email,
            "authentication_token" => student.authentication_token,
            "profile" => "student",
            "courses_count" => 1,
            "courses" => [course.access_code]
          )
        end

        it "should allow access with authentication_token after the sign in" do
          get "/api/v1/events.json",
              user_email: student.email, user_token: student.authentication_token
          expect(controller.current_user).to eq(student.user)
        end
      end

      context "incorrect authentication" do

        let(:profile) { :student }

        def do_action
          post "/api/v1/users/sign_in.json", student_hash.to_json
        end

        context "incorrect password" do
          let(:student_hash) { { student: { email: student.email, password: 'abcdefgh' } } }
          it_behaves_like "incorrect sign in"
        end

        context "incorrect email" do
          let(:student_hash) { { student: { email: "incorrect.email@gmail.com", password: password } } }
          it_behaves_like "incorrect sign in"
        end
      end
    end

    context "already signed in" do
      describe "redirect to dashboard when accessing login page" do
        include Warden::Test::Helpers
        before do
          Warden.test_mode!
          login_as student.user, scope: :user
          get "/sign_in"
        end
        after { Warden.test_reset! }
        it { expect(last_response.status).to eq(302) }
        it { expect(last_response.location).to match(%r{/dashboard/student$}) }
      end
    end
  end

  describe "teacher" do
    describe "POST /api/v1/users/sign_in" do

      context "correct authentication" do

        before(:each) do
          2.times.map { create(:course, teacher: teacher) }.each do |course|
            5.times { course.students << create(:student) }
            create(:notification, course: course)
          end

          post "/api/v1/users/sign_in", { user: { email: teacher.email, password: password } }.to_json
        end

        it { expect(last_response.status).to eq(200) }
        it { expect(controller.current_user).to eq(teacher.user) }

        it do
          expect(json).to eq(
            "root_path" => "/dashboard/teacher",
            "id" => teacher.user.id,
            "name" => teacher.name,
            "phone_number" => teacher.phone_number,
            "email" => teacher.email,
            "authentication_token" => teacher.authentication_token,
            "completed_tutorial" => teacher.completed_tutorial,
            "profile" => "teacher",
            "courses_count" => 2,
            "students_count" => 10,
            "notifications_count" => 2
          )
        end

        it "should allow access with authentication_token after the sign in" do
          # TODO: Implement some endpoint to test this feature
          get "/api/v1/events.json",
              user_email: teacher.email, user_token: teacher.authentication_token
          expect(controller.current_user).to eq(teacher.user)
        end
      end

      context "incorrect authentication" do

        let(:profile) { :teacher }

        def do_action
          post "/api/v1/users/sign_in.json", teacher_hash.to_json
        end

        context "incorrect password" do
          let(:teacher_hash) { { user: { email: teacher.email, password: 'abcdefgh' } } }
          it_behaves_like "incorrect sign in"
        end

        context "incorrect email" do
          let(:teacher_hash) { { user: { email: "incorrect.email@gmail.com", password: password } } }
          it_behaves_like "incorrect sign in"
        end
      end
    end

    context "already signed in" do
      describe "redirect to dashboard when accessing login page" do
        include Warden::Test::Helpers
        before do
          Warden.test_mode!
          login_as teacher.user, scope: :user
          get "/sign_in"
        end
        after { Warden.test_reset! }
        it { expect(last_response.status).to eq(302) }
        it { expect(last_response.location).to match(%r{/dashboard/teacher$}) }
      end
    end
  end
end
