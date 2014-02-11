require 'spec_helper'

describe Api::V1::EventsController do
  let!(:organization) { create :organization }
  let(:event) { build(:event, title: "TEST EVENT", organization: organization) }

  describe "POST #create" do
    before do
      post :create, event: event.attributes, organization_id: event.organization
    end

    it "should have created the event" do
      expect(Event.first.title).to be_eql event[:title]
    end
  end

  describe "GET #new" do
    before do
      get :new, organization_id: organization.uuid
    end

    it { expect(response).to render_template('new') }
  end

  describe "GET #edit" do
    before do
      event.save!
      get :edit, organization_id: organization.uuid, id: event.uuid
    end

    it { expect(response).to render_template('edit') }
    it { expect(assigns[:event]).to eq event }
  end
end
