require 'spec_helper'

describe Api::V1::EventsController do

  let(:student) { create(:student) }
  let(:course) { create(:course, students: [student]) }
  let!(:event) { create(:event, course: course) }

  describe "GET /api/v1/events" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      def do_action
        get "/api/v1/events.xml", auth_params
      end

      it_behaves_like "request invalid content type XML"

      context "valid content type" do

        let!(:earlier_event) { create(:event, course: course, start_at: event.start_at - 1) }
        let!(:event_from_another_course) { create(:event) }

        before(:each) do
          get "/api/v1/events.json", auth_params(student)
        end

        it { expect(response).to be_success }
        it { expect(json[0]["course"]["uuid"]).to eq(course.uuid) }

        describe "events" do

          subject do
            json.map { |event| event["uuid"] }
          end

          it { expect(json.length).to eq(2) }
          it { expect(subject).to include(event.uuid) }
          it { expect(subject.last).to eq(event.uuid) }
          it { expect(subject).to include(earlier_event.uuid) }
          it { expect(subject.first).to eq(earlier_event.uuid) }
          it { expect(subject).to_not include(event_from_another_course.uuid) }
        end
      end
    end
  end

  describe "GET /api/v1/events/1/attend" do

    let(:message) { create :timeline_user_message }

    before do
      create(:timeline_interaction, timeline: event.timeline, interaction: message)
    end

    it_behaves_like "API authentication required"

    context "authenticated" do

      describe "request invalid content type" do
        def do_action
          event.status = "opened"
          event.save!
          get "/api/v1/events/#{event.uuid}/attend.xml", auth_params
        end

        it_behaves_like "request invalid content type XML"
      end

      context "valid content type" do

        def do_action
          get "/api/v1/events/#{event.uuid}/attend.json", auth_params
        end

        before(:each) do
          do_action
        end

        it_behaves_like "closed event"

        context "unopened event" do
          let(:event) { create(:event, status: 'available', title: "New event") }
          it { expect(response.status).to eq 403 }
        end


        context "opened event" do
          let(:event) { create(:event, status: 'opened', title: "New event", topics: [topic], polls: [poll]) }
          let(:topic) { build(:topic) }
          let(:poll) { create(:poll, options: [option]) }
          let(:option) { create(:option) }

          subject { json }

          it { expect(response).to be_success }
          it { expect(subject["channel"]).to eq event.channel }
          it { expect(subject["student_message_event"]).to eq event.student_message_event }
          it { expect(subject["up_down_vote_message_event"]).to eq event.up_down_vote_message_event }
          it { expect(subject["release_poll_event"]).to eq event.release_poll_event }
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
                get "/api/v1/events/#{event.uuid}/attend.json", auth_params(student)
              end

              it { expect(subject["timeline"]["messages"][0]["already_voted"]).to eq "up" }
            end

            context "down" do
              before do
                message.down_by(student)
                get "/api/v1/events/#{event.uuid}/attend.json", auth_params(student)
              end

              it { expect(subject["timeline"]["messages"][0]["already_voted"]).to eq "down" }
            end
          end
        end
      end
    end
  end

  describe "GET /api/v1/events/1/timeline" do

    let(:message) { create :timeline_user_message }
    let!(:timeline_interaction) { create(:timeline_interaction, timeline: event.timeline, interaction: message) }

    it_behaves_like "API authentication required"

    context "authenticated" do

      def do_action
        get "/api/v1/events/#{event.uuid}/timeline.xml", auth_params
      end

      it_behaves_like "request invalid content type XML"

      context "valid content type" do

        before(:each) do
          get "/api/v1/events/#{event.uuid}/timeline.json", auth_params
        end

        it { expect(response).to be_success }
        it { expect(json.length).to eq(1) }
        it { expect(json["event"]["title"]).to eq(event.title) }
        it { expect(json["event"]["timeline"]["messages"].length).to eq(1) }


        it do
            expect { get "/api/v1/events/989898/timeline.json", auth_params }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
