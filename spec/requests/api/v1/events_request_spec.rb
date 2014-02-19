require 'spec_helper'

describe Api::V1::EventsController do

  let!(:organization) { create(:organization) }
  let!(:event) { create(:event, title: "New event", organization: organization) }

  describe "GET /api/v1/organizations/1/events" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      let!(:event_from_another_organization) { create(:event) }

      def do_action
        get "/api/v1/organizations/#{organization.uuid}/events.xml"
      end

      it_behaves_like "request invalid content type XML"

      context "valid content type" do

        context "when receives valid organization uuid" do

          before(:each) do
            get "/api/v1/organizations/#{organization.uuid}/events.json"
          end

          it { expect(response).to be_success }
          it { expect(json.length).to eq(1) }
          it { expect(json[0]["title"]).to eq(event.title) }
          it { expect(json[0]["organization_id"]).to eq(organization.id) }
          it { expect(json[0]["teacher"]["name"]).to eq(event.teacher.name) }
        end

        context "when receives an invalid organization uuid" do

          it do
            expect { get '/api/v1/organizations/999/events.json' }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end
  end

  describe "GET /api/v1/organizations/1/events/1/attend" do

    let(:message) { create :timeline_user_message }

    before do
      create(:timeline_interaction, timeline: event.timeline, interaction: message)
    end

    it_behaves_like "API authentication required"

    context "authenticated" do

      def do_action
        get "/api/v1/organizations/#{organization.uuid}/events/#{event.uuid}/attend.xml"
      end


      context "valid content type" do

        before(:each) do
          get "/api/v1/organizations/#{organization.uuid}/events/#{event.uuid}/attend.json"
        end

        context "unopened event" do
          let(:event) { create(:event, status: 'available', title: "New event", organization: organization) }
          it { expect(response.status).to eq 403 }
        end

        context "opened event" do
          let(:topic) { build(:topic) }
          let(:event) { create(:event, status: 'opened', title: "New event", organization: organization, topics: [topic]) }

          subject { json["event"] }

          it_behaves_like "request invalid content type XML"

          it { expect(response).to be_success }
          it { expect(subject["channel"]).to eq event.channel }
          it { expect(subject["student_message_event"]).to eq event.student_message_event }
          it { expect(subject["up_down_vote_message_event"]).to eq event.up_down_vote_message_event }
          it { expect(subject["receive_poll_event"]).to eq event.receive_poll_event }
          it { expect(subject["receive_rating_event"]).to eq event.receive_rating_event }
          it { expect(subject["timeline"]["timeline_interactions"][0]["interaction"]["content"]).to eq(message.content)}
          it { expect(subject["topics"]).to include({"description" => topic.description}) }

          # The approach bellow is necessary due to approximation errors
          it { expect(Time.parse(subject["timeline"]["created_at"]).to_i).to eq event.timeline.created_at.to_i }
          it { expect(Time.parse(subject["timeline"]["updated_at"]).to_i).to eq event.timeline.updated_at.to_i }
        end
      end
    end
  end

  describe "GET /api/v1/organizations/1/events/1/timeline" do

    let(:message) { create :timeline_user_message }
    let!(:timeline_interaction) { create(:timeline_interaction, timeline: event.timeline, interaction: message) }

    it_behaves_like "API authentication required"

    context "authenticated" do

      let!(:event_from_another_organization) { create(:event) }

      def do_action
        get "/api/v1/organizations/#{organization.uuid}/events/#{event.uuid}/timeline.xml"
      end

      it_behaves_like "request invalid content type XML"

      context "valid content type" do

        context "when receives valid organization uuid and event uuid" do

          before(:each) do
            get "/api/v1/organizations/#{organization.uuid}/events/#{event.uuid}/timeline.json"
          end

          it { expect(response).to be_success }
          it { expect(json.length).to eq(1) }
          it { expect(json["event"]["title"]).to eq(event.title) }
          it { expect(json["event"]["timeline"]["timeline_interactions"].length).to eq(1) }
          it { expect(json["event"]["timeline"]["timeline_interactions"][0]["interaction_type"]).to eq(timeline_interaction.interaction_type) }
        end

        context "when receives an invalid event uuid" do

          it do
            expect { get "/api/v1/organizations/#{organization.uuid}/events/989898/timeline.json" }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end
  end
end
