require 'spec_helper'

describe Api::V1::StudentsController do
  let!(:organization) { create(:organization) }
  let!(:student) { create(:student, organization: organization) }
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

  describe "GET /api/v1/students/login" do
    before(:each) do
      post "/api/v1/students/login"
    end

    let(:timeline) do
      json["organization"]["events"][0]["timeline"]
    end

    it { expect(timeline["messages"].size).to eq(2) }
    it { expect(timeline["messages"][0]["content"]).to eq("First message") }
    it { expect(timeline["messages"][1]["content"]).to eq("Second message") }
  end
end