require 'spec_helper'

describe Api::V1::Teacher::EventsController do

  let(:teacher) { create(:teacher) }
  let(:course) { create(:course, teacher: teacher) }
  let(:event) { create(:event, course: course) }

  let(:event_pusher_events) { EventPusherEvents.new(teacher) }

  describe "GET /api/v1/teacher/events/:uuid.json" do

    let(:topic) { create(:topic) }
    let(:thermometer) { create(:thermometer) }
    let(:poll) { create(:poll, options: [option]) }
    let(:option) { create(:option) }
    let(:media_with_url) { create(:media, url: "http://www.example.com", file: nil) }
    #let(:media_with_file) { create(:media, file: Tempfile.new("test"), url: nil) }
    let(:beacon) { create(:beacon) }
    let(:personal_note) { create(:personal_note) }
    let!(:event) do
      create(:event,
             topics: [topic],
             thermometers: [thermometer],
             polls: [poll],
             medias: [media_with_url],
             personal_notes: [personal_note],
             beacon: beacon
            )
    end

    it_behaves_like "API authentication required"

    context "authenticated" do

      def do_action
        get "/api/v1/teacher/events/#{event.uuid}.xml", auth_params(teacher)
      end

      it_behaves_like "request invalid content type XML"

      context "valid content type" do

        def do_action
          get "/api/v1/teacher/events/#{event.uuid}.json", auth_params(teacher)
        end

        before(:each) do
          do_action
        end

        it { expect(last_response.status).to eq(200) }

        describe "resource" do

          let(:target) { event }
          let(:media) { media_with_url }

          subject { json }
          it_behaves_like "request return check", %w(id title uuid duration channel status start_at)

          it { expect(last_response.status).to eq(200) }

          describe "pusher events" do
            let(:target) { event_pusher_events }
            subject { json }
            it_behaves_like "request return check", %w(student_message_event up_down_vote_message_event)
          end

          describe "peronal_note" do
            let(:target) { personal_note }
            subject { json["personal_notes"][0] }
            it_behaves_like "request return check", %w(content)
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

          describe "thermometer" do
            let(:target) { thermometer }
            subject { json["thermometers"][0] }
            it_behaves_like "request return check", %w(uuid content)
          end

          describe "media with URL" do
            let(:target) { media_with_url }
            subject { json["medias"].find { |m| m["uuid"] == target.uuid } }
            it_behaves_like "request return check", %w(uuid title description category url released_at)
          end

          #describe "media with File" do
          #  let(:target) { media_with_file }
          #  subject { json["medias"].find { |m| m["uuid"] == target.uuid } }
          #  it_behaves_like "request return check", %w(uuid title description category released_at)

          #  it { expect(subject["url"]).to eq target.file.url }
          #end
        end
      end
    end
  end

  describe "POST /api/v1/teacher/events.json" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      let(:event_template) { build(:event, title: "TEST EVENT", course: course) }

      let(:topic) { build :topic, timeline: event_template.timeline }
      let(:thermometer) { build :thermometer, timeline: event_template.timeline }
      let(:poll) { build :poll, timeline: event_template.timeline }
      let(:correct_option) { build :option, content: "Correct Option", correct: true, poll: poll }
      let(:incorrect_option) { build :option, content: "Incorrect Option", correct: false, poll: poll }
      let(:options) { [correct_option, incorrect_option] }
      let(:personal_note) { build :personal_note }
      let(:media_with_url) { build :media, timeline: event_template.timeline }
      #let(:media_with_file) { build :media_with_file, timeline: event_template.timeline }
      let(:start_at) { event_template.start_at.strftime('%d/%m/%Y %H:%M') }

      let(:params_hash) do
        {
          event: {
            "course_id" => event_template.course_id,
            "title" => event_template.title,
            "duration" => event_template.duration,
            "start_at" => start_at,
            topics: [topic.attributes],
            thermometers: [thermometer.attributes],
            polls: [poll.attributes.merge(
              options: [
                correct_option.attributes,
                incorrect_option.attributes
              ]
            )],
            personal_notes: [personal_note.attributes],
            medias: [
              media_with_url.attributes
              #media_with_file.attributes.merge({ file: Rack::Test::UploadedFile.new(media_with_file.file.path) })
            ]
          }
        }
      end

      def do_action
        post "/api/v1/teacher/events.json", auth_params(teacher).merge(params_hash).to_json
      end

      it "should create the event" do
        expect do
          do_action
        end.to change{ Event.count }.from(0).to(1)
      end


      context "trying to create an invalid event" do
        before :each do
          event_template.course = nil
          do_action
        end

        it { expect(last_response.status).to eq(400) }
        it { expect(json['errors']).to have_key('course') }
      end

      pending "trying to create event on another teacher's course"

      context "creating an event" do

        before do
          do_action
        end

        let(:event) { Event.order('created_at desc').first }
        subject { event }

        it { expect(subject.title).to eq(event_template[:title]) }

        it { expect(subject.topics.count).to eq 1 }
        describe "topic" do
          subject { event.topics.first }
          it_behaves_like "creating an artifact"
          it { expect(subject.description).to eq topic.description }
        end

        it { expect(subject.thermometers.count).to eq 1 }
        describe "thermometer" do
          subject { event.thermometers.first }
          it_behaves_like "creating an artifact"
          it { expect(subject.content).to eq thermometer.content }
        end

        it { expect(subject.polls.count).to eq 1 }
        describe "poll" do
          subject { event.polls.first }
          it_behaves_like "creating an artifact"
          it { expect(subject.content).to eq poll.content }

          describe "options" do
            it { expect(subject.options.count).to eq 2 }
            it { expect(subject.options.map(&:content)).to match_array options.map(&:content) }
            it { expect(subject.options.map(&:correct)).to match_array options.map(&:correct) }
          end
        end

        it { expect(subject.personal_notes.count).to eq 1 }
        it { expect(subject.personal_notes.first.content).to eq personal_note.content }
        it { expect(subject.personal_notes.first.done).to be_nil }

        #it { expect(subject.medias.count).to eq 2 }
        it { expect(subject.medias.count).to eq 1 }

        describe "media with url" do
          subject { event.medias.first }
          it_behaves_like "creating an artifact"
          it { expect(subject.title).to eq media_with_url.title }
          it { expect(subject.description).to eq media_with_url.description }
          it { expect(subject.category).to eq media_with_url.category }
          it { expect(subject.url).to eq media_with_url.url }
        end

        #describe "media with file" do
        #  subject { event.medias.last }
        #  it_behaves_like "creating an artifact"
        #  it { expect(subject.title).to eq media_with_file.title }
        #  it { expect(subject.description).to eq media_with_file.description }
        #  it { expect(subject.category).to eq media_with_file.category }
        #  it { expect(subject.file.file.identifier).to eq media_with_file.file.file.identifier }
        #end

        it { expect(subject.start_at.strftime('%d/%m/%Y %H:%M')).to eq(start_at) }
      end

    end
  end

  describe "PATCH /api/v1/teacher/events/:uuid.json" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      pending "invalid event"

      let(:title) { "NEW TITLE" }
      let(:params_hash) { { event: { title: title } } }

      def do_action
        patch "/api/v1/teacher/events/#{event.uuid}.json", auth_params(teacher).merge(params_hash).to_json
      end

      before do
        event.save!
        do_action
      end

      it { expect(event.reload.title).to eq title }
    end
  end

  describe "PATCH /api/v1/teacher/events/:uuid/open.json" do

    def do_action
      patch "/api/v1/teacher/events/#{event.uuid}/open.json", auth_params(teacher).to_json
    end

    before do
      event.save!
      Timecop.freeze
      CoursePusher.any_instance.should_receive(:open).once
      do_action
    end

    it { expect(last_response.status).to eq(200) }
    it { expect(json["uuid"]).to eq(event.uuid) }
    it { expect(event.reload.status).to eq('opened') }
    it { expect(event.reload.opened_at.to_i).to eq(Time.now.to_i) }
    it { expect(json["channel"]).to eq event.channel }
    it { expect(json["student_message_event"]).to eq event_pusher_events.student_message_event }
    it { expect(json["up_down_vote_message_event"]).to eq event_pusher_events.up_down_vote_message_event }

    context "opening event again" do
      before do
        Timecop.freeze(Time.now + 1)
        CoursePusher.any_instance.stub(:close)
        do_action
      end

      it { expect(last_response.status).to eq(304) }
      it { expect(event.reload.opened_at.to_i).not_to eq(Time.now.to_i) }
    end
  end

  describe "PATCH /api/v1/teacher/events/:uuid/close.json" do

    let(:event) { create(:event, status: 'opened') }

    def do_action
      patch "/api/v1/teacher/events/#{event.uuid}/close.json", auth_params(teacher).to_json
    end

    before do
      event.save!
      Timecop.freeze
      EventPusher.any_instance.should_receive(:close).once
      do_action
    end

    it { expect(event.reload.status).to eq 'closed' }
    it { expect(event.reload.closed_at.to_i).to eq DateTime.now.to_i }

    context "closing event again" do
      before do
        Timecop.freeze(Time.now + 1)
        EventPusher.any_instance.stub(:close)
        do_action
      end

      it { expect(last_response.status).to eq(304) }
      it { expect(event.reload.closed_at.to_i).not_to eq(Time.now.to_i) }
    end
  end

  describe "DELETE /api/v1/teacher/events/:uuid.json" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      def do_action
        delete "/api/v1/teacher/events/#{event.uuid}.json", auth_params(teacher).to_json
      end

      before do
        event.save!
      end

      it "should destroy the event" do
        expect do
          do_action
        end.to change(Event, :count).by(-1)
      end
    end
  end
end
