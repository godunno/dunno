require 'spec_helper'

describe Api::V1::CoursesController do

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
  let(:pusher_events) { EventPusherEvents.new(student) }

  describe "GET /api/v1/courses" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      def do_action
        get "/api/v1/courses.xml", auth_params
      end

      it_behaves_like "request invalid content type XML"

      context "valid content type" do

        let!(:earlier_event) { create(:event, course: course, start_at: event.start_at - 1) }
        let!(:event_from_another_course) { create(:event) }

        before(:each) do
          get "/api/v1/courses.json", auth_params(student)
        end

        it { expect(response).to be_success }

        describe "course" do

          let(:target) { course }
          let(:media) { media_with_url }
          let(:course_json) { json[0] }
          subject { course_json }
          it_behaves_like "request return check", %w(id name uuid start_date end_date start_time end_time classroom weekdays)

          it { expect(response).to be_success }

          describe "events" do

            subject do
              course_json["events"].map { |event| event["uuid"] }
            end

            it { expect(subject.length).to eq(2) }
            it { expect(subject).to include(event.uuid) }
            it { expect(subject.last).to eq(event.uuid) }
            it { expect(subject).to include(earlier_event.uuid) }
            it { expect(subject.first).to eq(earlier_event.uuid) }
            it { expect(subject).to_not include(event_from_another_course.uuid) }
          end

          describe "event" do

            let(:event_json) { course_json["events"][1] }
            subject { event_json }

            describe "pusher events" do
              let(:target) { pusher_events }
              subject { event_json }
              it_behaves_like "request return check", %w(student_message_event up_down_vote_message_event receive_rating_event release_poll_event release_media_event close_event)
            end

            describe "topic" do
              let(:target) { topic }
              subject { event_json["topics"][0] }
              it_behaves_like "request return check", %w(id description)
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

            describe "thermometer" do
              let(:target) { thermometer }
              subject { event_json["thermometers"][0] }
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
          end

        end
      end
    end
  end
end
