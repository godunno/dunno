require 'spec_helper'

describe Api::V1::SessionsController do
  let(:password) { '12345678' }
  let(:student) { create(:student, password: password) }

  describe "POST /api/v1/students/sign_in" do

    context "correct authentication" do
      before(:each) do
        post "/api/v1/students/sign_in", { student: { email: student.email, password: password } }
      end

      it { expect(response).to be_successful }
      it { expect(json["authentication_token"]).to eq(student.authentication_token) }
      it { expect(controller.current_student).to eq(student) }

      it "should allow access with authentication_token after the sign in" do
        get "/api/v1/organizations/#{student.organization.uuid}/events.json",
          { student_email: student.email, student_token: student.authentication_token }
        expect(controller.current_student).to eq(student)
      end
    end
  end

  context "incorrect password" do
    before(:each) do
      post "/api/v1/students/sign_in", { student: { email: student.email, password: 'abcdefgh' } }
    end

    it { expect(response.code).to eq "401" }
  end

  context "incorrect email" do
    before(:each) do
      post "/api/v1/students/sign_in", { student: { email: "incorrect.email@gmail.com", password: password } }
    end

    it { expect(response.code).to eq "401" }
  end
end
