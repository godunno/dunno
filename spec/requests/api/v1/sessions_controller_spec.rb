require 'spec_helper'

describe Api::V1::SessionsController do
  let(:password) { '12345678' }
  let!(:organization) { create(:organization) }
  let!(:student) { create(:student, organization: organization, password: password) }
  let!(:event) { create(:event, organization: organization) }
  let!(:message_one) do
    message = create(:timeline_user_message, content: "First message")
    create(:timeline_interaction, timeline: event.timeline, interaction: message)
    message
  end
  let!(:message_two) do
   message = create(:timeline_user_message, content: "Second message")
   create(:timeline_interaction, timeline: event.timeline, interaction: message)
   message
  end

  describe "POST /api/v1/students/sign_in" do

    context "correct authentication" do

      before(:each) do
        post "/api/v1/students/sign_in", { student: { email: student.email, password: password } }
      end

      it { expect(response).to be_successful }
      it { expect(json["authentication_token"]).to eq(student.authentication_token) }
      it { expect(controller.current_student).to eq(student) }

      describe "organization data" do
        let(:timeline) do
          json["organization"]["events"][0]["timeline"]
        end

        it { expect(timeline["messages"].size).to eq(2) }
        it { expect(timeline["messages"][0]["content"]).to eq("First message") }
        it { expect(timeline["messages"][1]["content"]).to eq("Second message") }
      end

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
