require 'spec_helper'

describe Api::V1::MessagesController do

  describe "POST /api/v1/timeline/messages", vcr: { match_requests_on: [:method, :host, :path]} do

    it_behaves_like "API authentication required"

    context "authenticated" do

      let!(:timeline) { event.timeline }
      let(:event) { create(:event) }
      let!(:student) { create(:student) }

      def do_action
        params = {
          timeline_message: {
            timeline_id: timeline.id,
            student_id: student.id,
            content: "Some message here"
          }
        }

        post "/api/v1/timeline/messages.xml", params.merge(auth_params).to_json
      end

      it_behaves_like "request invalid content type XML"

      context "valid content type" do

        context "when receives valid timeline id" do

          let(:message_params) do
            {
              timeline_message: {
                timeline_id: timeline.id,
                student_id: student.id,
                content: "Some message here"
              }
            }
          end

          context "valid content" do

            before(:each) do
              post "/api/v1/timeline/messages.json", message_params.merge(auth_params).to_json
            end

            it { expect(last_response.status).to eq(201) }
            it { expect(json["content"]).to eq("Some message here") }
            it { expect(json["student_id"]).to eq(student.id) }
          end

          def do_action
            post "/api/v1/timeline/messages.json", message_params.merge(auth_params).to_json
          end

          it_behaves_like "closed event"

          context "with invalid content" do
            let(:message_params) do
              {
                timeline_message: {
                  timeline_id: timeline.id,
                  student_id: student.id,
                  content: ""
                }
              }
            end

            before(:each) do
              post "/api/v1/timeline/messages.json", message_params.merge(auth_params).to_json
            end

            it { expect(json["errors"]).to eq(["Content não pode ficar em branco"]) }
          end
        end

        context "when does not receives valid timeline id" do
          let(:message_params) do
            {
              timeline_message: {
                timeline_id: "989898",
                student_id: student.id,
                content: "Some message here"
              }
            }
          end

          it do
            expect { post "/api/v1/timeline/messages.json", message_params.merge(auth_params).to_json }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end
  end

  describe "POST /api/v1/timeline/messages/:id/up", vcr: { match_requests_on: [:method, :host, :path]} do

    it_behaves_like "API authentication required"

    context "authenticated" do

      let(:event) { create(:event) }
      let(:student) { create(:student) }
      let(:message) { create(:timeline_message) }

      before do
        create(:timeline_interaction, timeline: event.timeline, interaction: message)
      end

      def do_action(message_id = message.id, student_id = student.id)
        post "/api/v1/timeline/messages/#{message_id}/up.json", { student_id: student_id }.merge(auth_params).to_json
      end

      it_behaves_like "closed event"

      context "valid message id and student id" do

        it "increases the message up votes" do
          expect do
            do_action
          end.to change(message.up_votes, :count).by(1)
        end

        it "triggers pusher event to notify pusher" do
          EventPusher.any_instance.should_receive(:up_down_vote_message).with(message).once
          do_action
        end

        it "responds with success" do
          do_action
          expect(last_response.status).to eq(200)
        end
      end

      context "context invalid message id" do

        it "responds with 404 not found" do
          expect do
            do_action("989898", student.id)
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "context invalid student id" do

        it "responds with 404 not found" do
          expect do
            do_action(message.id, "989898")
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe "POST /api/v1/timeline/messages/:id/down", vcr: { match_requests_on: [:method, :host, :path]} do

    it_behaves_like "API authentication required"

    context "authenticated" do

      let(:event) { create(:event) }
      let(:student) { create(:student) }
      let(:message) { create(:timeline_message) }

      before do
        create(:timeline_interaction, timeline: event.timeline, interaction: message)
      end

      def do_action(message_id = message.id, student_id = student.id)
        post "/api/v1/timeline/messages/#{message_id}/down.json", { student_id: student_id }.merge(auth_params).to_json
      end

      it_behaves_like "closed event"

      context "valid message id and student id" do

        it "increases the message down votes" do
          expect do
            do_action
          end.to change(message.down_votes, :count).by(1)
        end

        it "triggers pusher event to notify pusher" do
          EventPusher.any_instance.should_receive(:up_down_vote_message).with(message).once
          do_action
        end

        it "responds with success" do
          do_action
          expect(last_response.status).to eq(200)
        end
      end

      context "context invalid message id" do

        it "responds with 404 not found" do
          expect do
            do_action("989898", student.id)
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "context invalid student id" do

        it "responds with 404 not found" do
          expect do
            do_action(message.id, "989898")
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
