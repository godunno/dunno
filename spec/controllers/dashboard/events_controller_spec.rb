require 'spec_helper'

describe Dashboard::EventsController do
  let!(:organization) { create :organization }
  let!(:teacher) { create :teacher }

  let(:event) { build(:event, title: "TEST EVENT", teacher: teacher, organization: organization) }

  before do
    sign_in :teacher, teacher
  end

  describe "POST #create" do

    it_behaves_like "Dashboard authentication required"

    context "authenticated" do

      it "should create the event" do
        expect do
          post :create, event: event.attributes, organization_id: event.organization
        end.to change{ Event.count}.from(0).to(1)
      end

      context "creating an event" do
        let(:topic) { build :topic, event: event }
        let(:thermometer) { build :thermometer, event: event }
        let(:start_at) { event.start_at.strftime('%d/%m/%Y %H:%M') }

        before do
          post :create, event: event.attributes.merge(
              "start_at" => start_at,
              topics_attributes: { "0" => topic.attributes },
              thermometers_attributes: { "0" => thermometer.attributes }
            ), organization_id: event.organization
        end

        subject { Event.first }

        it { expect(subject.title).to eq(event[:title]) }
        it { expect(subject.teacher.name).to eq(teacher.name) }
        it { expect(subject.topics.first.description).to eq topic.description }
        it { expect(subject.thermometers.first.content).to eq thermometer.content }
        it { expect(subject.start_at.strftime('%d/%m/%Y %H:%M')).to eq(start_at) }
      end

    end
  end

  describe "GET #new" do

    it_behaves_like "Dashboard authentication required"

    context "authenticated" do

      before do
        get :new, organization_id: organization.uuid
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
        get :edit, organization_id: organization.uuid, id: event.uuid
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
        patch :update, organization_id: organization.uuid, id: event.uuid, event: event.attributes
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
          delete :destroy, organization_id: organization.uuid, id: event.uuid
        end.to change(Event, :count).by(-1)
      end
    end
  end

  describe "GET #index" do

    it_behaves_like "Dashboard authentication required"

    context "authenticated" do

      let!(:event_from_another_organization) { create(:event, teacher: teacher, organization: create(:organization)) }
      let!(:event_from_another_teacher) { create(:event, teacher: create(:teacher), organization: organization) }

      before do
        event.save!
        get :index, organization_id: organization.uuid
      end

      it { expect(response).to render_template('index') }
      it { expect(assigns[:organization]).to eq organization }
      it { expect(assigns[:events]).to include event }
      it { expect(assigns[:events]).not_to include event_from_another_organization }
      it { expect(assigns[:events]).not_to include event_from_another_teacher }
    end
  end

  describe "PATCH #open" do

    let(:event) { create(:event, status: 'available', organization: organization) }

    it "should open the event" do
      expect do
        patch :open, organization_id: organization.uuid, id: event.uuid
      end.to change{event.reload.status}.from('available').to('opened')
    end
  end
end
