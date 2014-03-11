require 'spec_helper'

describe Api::V1::EventsController do

  let!(:organization) { create(:organization) }
  let!(:event) { create(:event, title: "New event", organization: organization) }

  describe "GET /api/v1/organizations/1/events" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      let!(:event_from_another_organization) { create(:event) }

      def do_action
        get "/api/v1/organizations/#{organization.uuid}/events.xml", auth_params
      end

      it_behaves_like "request invalid content type XML"

      context "valid content type" do

        context "when receives valid organization uuid" do

          before(:each) do
            get "/api/v1/organizations/#{organization.uuid}/events.json", auth_params
          end

          it { expect(response).to be_success }
          it { expect(json.length).to eq(1) }
          it { expect(json[0]["title"]).to eq(event.title) }
          it { expect(json[0]["organization_id"]).to eq(organization.id) }
          it { expect(json[0]["teacher"]["name"]).to eq(event.teacher.name) }
        end

        context "when receives an invalid organization uuid" do

          it do
            expect { get '/api/v1/organizations/999/events.json', auth_params }.to raise_error(ActiveRecord::RecordNotFound)
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
        get "/api/v1/organizations/#{organization.uuid}/events/#{event.uuid}/attend.xml", auth_params
      end


      context "valid content type" do

        before(:each) do
          get "/api/v1/organizations/#{organization.uuid}/events/#{event.uuid}/attend.json", auth_params
        end

        context "unopened event" do
          let(:event) { create(:event, status: 'available', title: "New event", organization: organization) }
          it { expect(response.status).to eq 403 }
        end

        context "opened event" do
          let(:event) { create(:event, status: 'opened', title: "New event", organization: organization, topics: [topic], polls: [poll]) }
          let(:topic) { build(:topic) }
          let(:poll) { create(:poll, options: [option]) }
          let(:option) { create(:option) }

          subject { json }

          it_behaves_like "request invalid content type XML"

          it { expect(response).to be_success }
          it { expect(subject["channel"]).to eq event.channel }
          it { expect(subject["student_message_event"]).to eq event.student_message_event }
          it { expect(subject["up_down_vote_message_event"]).to eq event.up_down_vote_message_event }
          it { expect(subject["receive_poll_event"]).to eq event.receive_poll_event }
          it { expect(subject["receive_rating_event"]).to eq event.receive_rating_event }
          it { expect(subject["close_event"]).to eq event.close_event }
          it { expect(subject["timeline"]["messages"][0]["content"]).to eq(message.content)}
          it { expect(subject["timeline"]["messages"][0]["already_voted"]).to be_nil }
          it { expect(subject["topics"]).to include({"id" => topic.id, "description" => topic.description}) }
          it { expect(subject["polls"].count).to eq 1 }
          it { expect(subject["polls"][0]["uuid"]).to eq poll.uuid }
          it { expect(subject["polls"][0]["content"]).to eq poll.content }
          it { expect(subject["polls"][0]["options"].count).to eq 1 }
          it { expect(subject["polls"][0]["options"][0]["uuid"]).to eq option.uuid }
          it { expect(subject["polls"][0]["options"][0]["content"]).to eq option.content }

          # The approach bellow is necessary due to approximation errors
          it { expect(Time.parse(subject["timeline"]["created_at"]).to_i).to eq event.timeline.created_at.to_i }
          it { expect(Time.parse(subject["timeline"]["updated_at"]).to_i).to eq event.timeline.updated_at.to_i }

          context "student already voted on the message" do

            let(:student) { create(:student) }

            context "up" do
              before do
                message.up_by(student)
                get "/api/v1/organizations/#{organization.uuid}/events/#{event.uuid}/attend.json", auth_params(student)
              end

              it { expect(subject["timeline"]["messages"][0]["already_voted"]).to eq "up" }
            end

            context "down" do
              before do
                message.down_by(student)
                get "/api/v1/organizations/#{organization.uuid}/events/#{event.uuid}/attend.json", auth_params(student)
              end

              it { expect(subject["timeline"]["messages"][0]["already_voted"]).to eq "down" }
            end
          end
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
        get "/api/v1/organizations/#{organization.uuid}/events/#{event.uuid}/timeline.xml", auth_params
      end

      it_behaves_like "request invalid content type XML"

      context "valid content type" do

        context "when receives valid organization uuid and event uuid" do

          before(:each) do
            get "/api/v1/organizations/#{organization.uuid}/events/#{event.uuid}/timeline.json", auth_params
          end

          it { expect(response).to be_success }
          it { expect(json.length).to eq(1) }
          it { expect(json["event"]["title"]).to eq(event.title) }
          it { expect(json["event"]["timeline"]["messages"].length).to eq(1) }
        end

        context "when receives an invalid event uuid" do

          it do
            expect { get "/api/v1/organizations/#{organization.uuid}/events/989898/timeline.json", auth_params }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end
  end
end
