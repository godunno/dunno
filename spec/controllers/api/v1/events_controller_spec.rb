require 'spec_helper'

describe Api::V1::EventsController do
  let!(:organization) { create :organization }
  let(:event) { build(:event, title: "TEST EVENT", organization: organization) }

  describe "POST #create" do
    before do
      post :create, event: event.attributes, organization_id: event.organization
    end

    it "should have created the event" do
      expect(Event.first.title).to eq event[:title]
    end
  end

  describe "GET #new" do
    before do
      get :new, organization_id: organization.uuid
    end

    it { expect(response).to render_template('new') }
    it { expect(assigns[:event]).to be_a Event }
  end

  describe "GET #edit" do
    before do
      event.save!
      get :edit, organization_id: organization.uuid, id: event.uuid
    end

    it { expect(response).to render_template('edit') }
    it { expect(assigns[:event]).to eq event }
  end

  describe "PATCH #update" do
    before do
      event.save!
      event.title = "NEW TITLE"
      patch :update, organization_id: organization.uuid, id: event.uuid, event: event.attributes
    end

    it { expect(Event.first.title).to eq event.title }
  end

  describe "DELETE #destroy" do
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
