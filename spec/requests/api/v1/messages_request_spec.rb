require 'spec_helper'

describe Api::V1::MessagesController do

  describe "POST /api/v1/timeline/messages" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      let!(:timeline) { create(:timeline) }
      let!(:student) { create(:student) }

      def do_action
        params = {
          timeline_user_message: {
            timeline_id: timeline.id,
            student_id: student.id,
            content: "Some message here"
          }
        }

        post "/api/v1/timeline/messages.xml", params
      end

      it_behaves_like "request invalid content type XML"

      context "valid content type" do

        context "when receives valid timeline id" do

          context "valid content" do
            let(:message_params) do
              {
                timeline_user_message: {
                  timeline_id: timeline.id,
                  student_id: student.id,
                  content: "Some message here"
                }
              }
            end

            before(:each) do
              post "/api/v1/timeline/messages.json", message_params
            end

            it { expect(response.status).to eq(201) }
            it { expect(json["content"]).to eq("Some message here") }
            it { expect(json["student_id"]).to eq(student.id) }
          end

          context "with invalid content" do
            let(:message_params) do
              {
                timeline_user_message: {
                  timeline_id: timeline.id,
                  student_id: student.id,
                  content: ""
                }
              }
            end

            before(:each) do
              post "/api/v1/timeline/messages.json", message_params
            end

            it { expect(json["errors"]["content"]).to include("não pode ficar em branco") }
          end
        end

        context "when does not receives valid timeline id" do
          let(:message_params) do
            {
              timeline_user_message: {
                timeline_id: "989898",
                student_id: student.id,
                content: "Some message here"
              }
            }
          end
          it do
            expect { post "/api/v1/timeline/messages.json", message_params }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end
  end
end
