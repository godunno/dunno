require 'spec_helper'

describe Api::V1::EventsController do

  let(:student) { create(:student) }
  let(:course) { create(:course, students: [student]) }
  let(:topic) { create(:topic) }
  let(:thermometer) { create(:thermometer) }
  let(:poll) { create(:poll, options: [option]) }
  let(:option) { create(:option) }
  let(:media_with_url) { build(:media, url: "http://www.example.com", file: nil) }
  let(:media_with_file) { build(:media, file: Tempfile.new("test"), url: nil) }
  let!(:event) do
    create(:event, course: course,
           topics: [topic],
           thermometers: [thermometer],
           polls: [poll],
           medias: [media_with_url, media_with_file])
  end
  let(:pusher_events) { PusherEvents.new(student) }

  before do
    [poll, media_with_url, media_with_file].each { |i| i.release! }
  end

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

        describe "event" do

          let(:target) { event }
          let(:media) { media_with_url }
          subject { json[1] }
          it_behaves_like "request return check", %w(id title uuid duration channel status start_at)

          it { expect(response).to be_success }

          describe "pusher events" do
            let(:target) { pusher_events }
            subject { json[1] }
            it_behaves_like "request return check", %w(student_message_event up_down_vote_message_event receive_rating_event release_poll_event release_media_event close_event)
          end

          describe "course" do
            let(:target) { course }
            subject { json[1]["course"] }
            it_behaves_like "request return check", %w(uuid)
          end

          describe "topic" do
            let(:target) { topic }
            subject { json[1]["topics"][0] }
            it_behaves_like "request return check", %w(id description)
          end

          it { expect(subject["polls"].count).to eq 1 }
          describe "poll" do
            let(:target) { poll }
            subject { json[1]["polls"][0] }
            it_behaves_like "request return check", %w(uuid content released_at)
          end

          it { expect(subject["polls"][0]["options"].count).to eq 1 }
          describe "option" do
            let(:target) { option }
            subject { json[1]["polls"][0]["options"][0] }
            it_behaves_like "request return check", %w(uuid content)
          end

          describe "thermometer" do
            let(:target) { thermometer }
            subject { json[1]["thermometers"][0] }
            it_behaves_like "request return check", %w(uuid content)
          end

          describe "media with URL" do
            let(:target) { media_with_url }
            subject { json[1]["medias"].find { |m| m["uuid"] == target.uuid } }
            it_behaves_like "request return check", %w(uuid title description category url released_at)
          end

          describe "media with File" do
            let(:target) { media_with_file }
            subject { json[1]["medias"].find { |m| m["uuid"] == target.uuid } }
            it_behaves_like "request return check", %w(uuid title description category released_at)

            it { expect(subject["url"]).to eq target.file.url }
          end
        end

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
          let(:event) { create(:event, status: 'opened', title: "New event", topics: [topic], polls: [poll], medias: [media_with_url, media_with_file]) }
          let(:topic) { build(:topic) }
          let(:poll) { create(:poll, options: [option]) }
          let(:option) { create(:option) }
          let(:media) { create(:media) }

          subject { json }

          it { expect(response).to be_success }

          describe "event" do
            let(:target) { event }
            subject { json }
            it_behaves_like "request return check", %w(channel)
          end

          describe "pusher events" do
            let(:target) { pusher_events }
            subject { json }
            it_behaves_like "request return check", %w(student_message_event up_down_vote_message_event receive_rating_event release_poll_event release_media_event close_event)
          end

          describe "message" do
            let(:target) { message }
            subject { json["timeline"]["messages"][0] }
            it_behaves_like "request return check", %w(content)

            it { expect(subject["already_voted"]).to be_nil }
          end

          describe "topic" do
            let(:target) { topic }
            subject { json["topics"][0] }
            it_behaves_like "request return check", %w(id description)
          end

          it { expect(subject["polls"].count).to eq 1 }
          describe "poll" do
            let(:target) { poll }
            subject { json["polls"][0] }
            it_behaves_like "request return check", %w(uuid content released_at)
          end

          it { expect(subject["polls"][0]["options"].count).to eq 1 }
          describe "option" do
            let(:target) { option }
            subject { json["polls"][0]["options"][0] }
            it_behaves_like "request return check", %w(uuid content)
          end

          describe "media with URL" do
            let(:target) { media_with_url }
            subject { json["medias"].find { |m| m["uuid"] == target.uuid } }
            it_behaves_like "request return check", %w(uuid title description category url released_at)
          end

          describe "media with File" do
            let(:target) { media_with_file }
            subject { json["medias"].find { |m| m["uuid"] == target.uuid } }
            it_behaves_like "request return check", %w(uuid title description category released_at)

            it { expect(subject["url"]).to eq target.file.url }
          end

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
