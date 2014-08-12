require 'spec_helper'

describe Api::V1::CoursesController do

  let(:student) { create(:student) }
  let(:course) { create(:course, students: [student]) }
  let(:topic) { create(:topic) }
  let(:thermometer) { create(:thermometer) }
  let(:poll) { create(:poll, options: [option]) }
  let(:option) { create(:option) }
  let(:media_with_url) { create(:media, url: "http://www.example.com", file: nil) }
  let(:media_with_file) { create(:media, file: Tempfile.new("test"), url: nil) }
  let!(:event) do
    create(:event, course: course,
           topics: [topic],
           thermometers: [thermometer],
           polls: [poll],
           medias: [media_with_url, media_with_file])
  end
  let(:event_pusher_events) { EventPusherEvents.new(student) }

  describe "GET /api/v1/courses" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      def do_action
        get "/api/v1/courses.xml", auth_params(student)
      end

      it_behaves_like "request invalid content type XML"

      context "valid content type" do

        let!(:earlier_event) { create(:event, course: course, start_at: event.start_at - 1) }
        let!(:another_course) { create(:course) }
        let!(:event_from_another_course) { create(:event, course: another_course) }

        before(:each) do
          get "/api/v1/courses.json", auth_params(student)
        end

        it { expect(last_response.status).to eq(200) }

        describe "collection" do

          subject { json.map {|course| course["uuid"]} }

          it { expect(subject).to include course.uuid }
          it { expect(subject).not_to include another_course.uuid }
        end

        describe "course" do

          let(:target) { course }
          let(:media) { media_with_url }
          let(:course_json) { json[0] }
          subject { course_json }
          it_behaves_like "request return check", %w(name uuid start_date end_date)

          it { expect(last_response.status).to eq(200) }

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
              let(:target) { event_pusher_events }
              subject { event_json }
              it_behaves_like "request return check", %w(student_message_event up_down_vote_message_event receive_rating_event release_poll_event release_media_event close_event)
            end

            describe "topic" do
              let(:target) { topic }
              subject { event_json["topics"][0] }
              it_behaves_like "request return check", %w(uuid description)
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

  describe "POST /api/v1/courses/:uuid/register" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      let(:new_course) { create :course }

      it { expect(student.courses).not_to include(new_course)}
      it { expect(new_course.students).to eq([]) }

      context "valid content type" do

        def do_action
          post "/api/v1/courses/#{uuid}/register.json", auth_params(student).to_json
        end

        before do
          do_action
        end

        context "existing course" do

          let(:uuid) { new_course.uuid }

          it { expect(last_response.status).to eq(200) }
          it { expect(new_course.students).to eq([student]) }
          it { expect(student.courses).to include(new_course) }
        end

        context "course not found" do
          let(:uuid) { "non-existent" }

          it { expect(last_response.status).to eq(404) }
        end

        context "already registered to course" do
          let(:uuid) { new_course.uuid }

          before do
            do_action
          end

          it { expect(last_response.status).to eq(400) }
          it { expect(new_course.students.reload).to eq([student]) }
        end
      end
    end
  end
end
