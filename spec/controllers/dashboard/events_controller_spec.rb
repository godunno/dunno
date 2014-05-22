require 'spec_helper'

describe Dashboard::EventsController do

  let!(:teacher) { create :teacher }
  let(:course) { create :course, teacher: teacher }
  let(:event) { build(:event, title: "TEST EVENT", course: course) }

  before do
    sign_in :teacher, teacher
  end

  describe "POST #create" do

    it_behaves_like "Dashboard authentication required"

    context "authenticated" do

      let(:event_template) { build(:event, title: "TEST EVENT", course: course) }

      it "should create the event" do
        expect do
          post :create, event: event_template.attributes
        end.to change{ Event.count }.from(0).to(1)
      end

      context "creating an event" do
        let(:topic) { build :topic, timeline: event_template.timeline }
        let(:thermometer) { build :thermometer, timeline: event_template.timeline }
        let(:poll) { build :poll, timeline: event_template.timeline }
        let(:correct_option) { build :option, content: "Correct Option", correct: true, poll: poll }
        let(:incorrect_option) { build :option, content: "Incorrect Option", correct: false, poll: poll }
        let(:options) { [correct_option, incorrect_option] }
        let(:personal_note) { build :personal_note }
        let(:media_with_url) { build :media }
        let(:media_with_file) { build :media_with_file }
        let(:start_at) { event_template.start_at.strftime('%d/%m/%Y %H:%M') }

        before do
          post :create, event: event_template.attributes.merge(
              "start_at" => start_at,
              topics_attributes: { "0" => topic.attributes },
              thermometers_attributes: { "0" => thermometer.attributes },
              polls_attributes: { "0" => poll.attributes.merge(
                options_attributes: {
                  "0" => correct_option.attributes,
                  "1" => incorrect_option.attributes
                }
              )},
              personal_notes_attributes: { "0" => personal_note.attributes },
              medias_attributes: {
                "0" => media_with_url.attributes,
                "1" => media_with_file.attributes.merge({ file: Rack::Test::UploadedFile.new(media_with_file.file.path) })
              }
            )
        end

        let(:event) { assigns(:event) }
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
        end

        it { expect(subject.polls.first.options.count).to eq 2 }
        it { expect(subject.polls.first.options.map(&:content)).to match_array options.map(&:content) }
        it { expect(subject.polls.first.options.map(&:correct)).to match_array options.map(&:correct) }

        it { expect(subject.personal_notes.count).to eq 1 }
        it { expect(subject.personal_notes.first.content).to eq personal_note.content }
        it { expect(subject.personal_notes.first.done).to be_nil }

        it { expect(subject.medias.count).to eq 2 }

        describe "media with url" do
          subject { event.medias.first }
          it_behaves_like "creating an artifact"
          it { expect(subject.title).to eq media_with_url.title }
          it { expect(subject.description).to eq media_with_url.description }
          it { expect(subject.category).to eq media_with_url.category }
          it { expect(subject.url).to eq media_with_url.url }
        end

        describe "media with file" do
          subject { event.medias.last }
          it_behaves_like "creating an artifact"
          it { expect(subject.title).to eq media_with_file.title }
          it { expect(subject.description).to eq media_with_file.description }
          it { expect(subject.category).to eq media_with_file.category }
          it { expect(subject.file.file.identifier).to eq media_with_file.file.file.identifier }
        end

        it { expect(subject.start_at.strftime('%d/%m/%Y %H:%M')).to eq(start_at) }
      end

    end
  end

  describe "GET #new" do

    it_behaves_like "Dashboard authentication required"

    context "authenticated" do

      before do
        get :new
      end

      it { expect(response).to render_template('new') }
      it { expect(assigns[:event]).to be_a Event }
    end
  end

  describe "GET #edit" do

    it_behaves_like "Dashboard authentication required"

    context "authenticated" do

      before do
        event.save!
        get :edit, id: event.uuid
      end

      it { expect(response).to render_template('edit') }
      it { expect(assigns[:event]).to eq event }
    end
  end

  describe "PATCH #update" do

    it_behaves_like "Dashboard authentication required"

    context "authenticated" do

      before do
        event.save!
        event.title = "NEW TITLE"
        patch :update, id: event.uuid, event: event.attributes
      end

      it { expect(Event.first.title).to eq event.title }
    end
  end

  describe "DELETE #destroy" do

    it_behaves_like "Dashboard authentication required"

    context "authenticated" do

      before do
        event.save!
      end

      it "should destroy the event" do
        expect do
          delete :destroy, id: event.uuid
        end.to change(Event, :count).by(-1)
      end
    end
  end

  describe "GET #index" do

    it_behaves_like "Dashboard authentication required"

    context "authenticated" do

      let!(:event_from_another_teacher) { create(:event, course: create(:course, teacher: create(:teacher))) }
      let!(:event_from_another_course) { create(:event, course: create(:course, teacher: teacher)) }

      before do
        event.save!
      end

      describe "all courses" do
        before do
          get :index
        end

        it { expect(response).to render_template('index') }
        it { expect(assigns[:events]).to include event }
        it { expect(assigns[:events]).to include event_from_another_course }
        it { expect(assigns[:events]).not_to include event_from_another_teacher }
      end

      describe "specifying course" do
        before do
          get :index, course_id: course.uuid
        end

        it { expect(response).to render_template('index') }
        it { expect(assigns[:events]).to include event }
        it { expect(assigns[:events]).not_to include event_from_another_teacher }
        it { expect(assigns[:events]).not_to include event_from_another_course }
      end
    end
  end

  describe "PATCH #open" do

    let(:event) { create(:event, status: 'available') }

    it "should open the event" do
      expect do
        patch :open, id: event.uuid
      end.to change{event.reload.status}.from('available').to('opened')
    end
  end

  describe "PATCH #close" do

    let(:event) { create(:event, status: 'opened') }

    before do
      Timecop.freeze
      EventPusher.any_instance.should_receive(:close).once
      patch :close, id: event.uuid
    end

    it { expect(event.reload.status).to eq 'closed' }
    it { expect(event.reload.closed_at.to_i).to eq DateTime.now.to_i }
  end
end
