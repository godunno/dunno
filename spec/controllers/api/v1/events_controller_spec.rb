require 'spec_helper'

describe Api::V1::EventsController do
  let!(:organization) { create :organization }
  describe "POST #create" do
    let(:event) { build(:event, title: "TEST EVENT", organization: organization) }
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
end
