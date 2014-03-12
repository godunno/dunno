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

      describe "timeline data" do
        let(:timeline) do
          json["organization"]["events"][0]["timeline"]
        end

        subject { timeline["messages"].map { |message| message["content"] } }

        it { expect(subject.size).to eq(2) }
        it { expect(subject).to include(message_one.content) }
        it { expect(subject).to include(message_two.content) }
      end

      it "should allow access with authentication_token after the sign in" do
        get "/api/v1/organizations/#{student.organization.uuid}/events.json",
          { student_email: student.email, student_token: student.authentication_token }
        expect(controller.current_student).to eq(student)
      end
    end
  end

  shared_examples "incorrect sign in" do

    before(:each) do
      post "/api/v1/students/sign_in.json", student_hash
    end

    it { expect(response.code).to eq "401" }
    it { expect(json["errors"].count).to eq 1 }
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
