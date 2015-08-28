require 'spec_helper'

describe Api::V1::SessionsController do
  let(:password) { '12345678' }
  let(:course) { create(:course) }

  let!(:profile) { create(:profile, user: create(:user, password: password)) }

  describe "POST /api/v1/users/sign_in" do

    context "correct authentication" do

      before(:each) do
        2.times.map { create(:course, teacher: profile) }.each do |course|
          5.times { course.students << create(:profile) }
          create(:notification, course: course)
        end

        post "/api/v1/users/sign_in", { user: { email: profile.email, password: password } }.to_json
      end

      it { expect(last_response.status).to eq(200) }
      it { expect(controller.current_user).to eq(profile.user) }

      it do
        expect(json).to eq(
          "root_path" => "/dashboard",
          "id" => profile.user.id,
          "name" => profile.name,
          "phone_number" => profile.phone_number,
          "email" => profile.email,
          "authentication_token" => profile.authentication_token,
          "profile" => "teacher",
          "courses_count" => 2,
          "students_count" => 10,
          "notifications_count" => 2,
          "created_at" => profile.user.created_at.utc.iso8601
        )
      end

      it "should allow access with authentication_token after the sign in" do
        # TODO: Implement some endpoint to test this feature
        get "/api/v1/events.json", user_email: profile.email, user_token: profile.authentication_token
        expect(controller.current_user).to eq(profile.user)
      end
    end

    context "incorrect authentication" do
      def do_action
        post "/api/v1/users/sign_in.json", teacher_hash.to_json
      end

      context "incorrect password" do
        let(:teacher_hash) { { user: { email: profile.email, password: 'abcdefgh' } } }
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
        login_as profile.user, scope: :user
        get "/sign_in"
      end
      after { Warden.test_reset! }
      it { expect(last_response.status).to eq(302) }
      it { expect(last_response.location).to match(%r{/dashboard$}) }
    end
  end
end
