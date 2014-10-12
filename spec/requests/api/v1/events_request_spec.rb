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
  let(:beacon) { create(:beacon) }
  let!(:event) do
    create(:event, course: course,
                   topics: [topic],
                   thermometers: [thermometer],
                   polls: [poll],
                   medias: [media_with_url, media_with_file],
                   beacon: beacon
          )
  end
  let(:event_pusher_events) { EventPusherEvents.new(student.user) }

  before do
    [poll, media_with_url, media_with_file].each(&:release!)
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

        it { expect(last_response.status).to eq(200) }

        describe "event" do

          let(:target) { event }
          let(:media) { media_with_url }
          subject { json[1] }
          it_behaves_like "request return check", %w(id uuid channel status start_at end_at)

          it { expect(last_response.status).to eq(200) }

          describe "pusher events" do
            let(:target) { event_pusher_events }
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
            it_behaves_like "request return check", %w(description)
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

    let(:author) { create(:student) }
    let(:message) { create(:timeline_message, student: author) }

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
          get "/api/v1/events/#{event.uuid}/attend.json", auth_params(student)
        end

        before(:each) do
          do_action
        end

        it_behaves_like "closed event"

        context "unopened event" do
          let(:event) { create(:event, status: 'available') }
          it { expect(last_response.status).to eq 403 }
        end

        context "opened event" do
          let(:event) { create(:event, status: 'opened', topics: [topic], polls: [poll], medias: [media_with_url, media_with_file]) }
          let!(:topic) { create(:topic) }
          let!(:poll) { create(:poll, options: [option]) }
          let(:option) { create(:option) }
          let!(:media) { create(:media) }

          subject { json }

          it { expect(last_response.status).to eq(200) }

          describe "Attendance created" do
            subject { Attendance.last }

            it { expect(subject.event).to eq(event) }
            it { expect(subject.student).to eq(student) }
          end

          describe "event" do
            let(:event_json) { json }
            let(:target) { event }
            subject { event_json }
            it_behaves_like "request return check", %w(channel)

            describe "pusher events" do
              let(:target) { event_pusher_events }
              subject { event_json }
              it_behaves_like "request return check", %w(student_message_event up_down_vote_message_event receive_rating_event release_poll_event release_media_event close_event)
            end

            describe "topic" do
              let(:target) { topic }
              subject { event_json["topics"][0] }
              it_behaves_like "request return check", %w(description)
            end

            it { expect(subject["polls"].count).to eq 1 }
            describe "poll" do
              let(:target) { poll }
              subject { event_json["polls"][0] }
              it_behaves_like "request return check", %w(uuid content released_at)
            end

            it { expect(subject["polls"][0]["options"].count).to eq 1 }
            describe "option" do
              let(:target) { option }
              subject { event_json["polls"][0]["options"][0] }
              it_behaves_like "request return check", %w(uuid content)
            end

            describe "media with URL" do
              let(:target) { media_with_url }
              subject { event_json["medias"].find { |m| m["uuid"] == target.uuid } }
              it_behaves_like "request return check", %w(uuid title description category url released_at)
            end

            describe "media with File" do
              let(:target) { media_with_file }
              subject { event_json["medias"].find { |m| m["uuid"] == target.uuid } }
              it_behaves_like "request return check", %w(uuid title description category released_at)

              it { expect(subject["url"]).to eq target.file.url }
            end

            describe "timeline" do
              let(:timeline_json) { event_json["timeline"] }
              let(:target) { event.timeline }
              subject { timeline_json }
              it_behaves_like "request return check", %w(start_at updated_at)

              describe "messages" do

                let(:message_json) { timeline_json["messages"][0] }
                let(:target) { message }
                subject { message_json }
                it_behaves_like "request return check", %w(uuid content)
                it { expect(subject["already_voted"]).to be_nil }

                describe "author" do
                  let(:target) { author }
                  subject { message_json["author"] }
                  it_behaves_like "request return check", %w(name avatar)
                end

                context "student already voted on the message" do

                  let(:student) { create(:student) }

                  context "up" do
                    before do
                      message.up_by(student)
                      get "/api/v1/events/#{event.uuid}/attend.json", auth_params(student)
                    end

                    it { expect(subject["already_voted"]).to eq "up" }
                    it { expect(subject["up_votes"]).to eq(1) }
                  end

                  context "down" do
                    before do
                      message.down_by(student)
                      get "/api/v1/events/#{event.uuid}/attend.json", auth_params(student)
                    end

                    it { expect(subject["already_voted"]).to eq "down" }
                    it { expect(subject["down_votes"]).to eq(1) }
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  describe "GET /api/v1/events/1/timeline" do

    let(:message) { create :timeline_message }
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

        it { expect(last_response.status).to eq(200) }
        it { expect(json.length).to eq(1) }
        it { expect(json["event"]["timeline"]["messages"].length).to eq(1) }

        it do
          expect { get "/api/v1/events/989898/timeline.json", auth_params }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe "PATCH #validate_attendance" do

    def beacon_hash(beacon)
      { uuid: beacon.uuid, minor: beacon.minor, major: beacon.major, title: beacon.title }
    end

    def do_action
      patch "/api/v1/events/#{event.uuid}/validate_attendance.json", auth_params(student).merge(beacon: beacon_hash(current_beacon)).to_json
    end

    let!(:attendance) { create(:attendance, event: event, student: student) }

    context "correct beacon" do

      let(:current_beacon) { beacon }

      before do
        do_action
        attendance.reload
      end

      it { expect(last_response.status).to eq(200) }
      it { expect(attendance.validated).to be_true }
    end

    context "incorrect beacon" do

      let(:current_beacon) { create(:beacon) }

      before do
        do_action
        attendance.reload
      end

      it { expect(last_response.status).to eq(400) }
      it { expect(attendance.validated).to be_false }
    end
  end
end
