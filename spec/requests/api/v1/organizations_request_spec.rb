require 'spec_helper'

describe Api::V1::OrganizationsController do
  let!(:organization) { create(:organization, name: "School 2.0") }

  describe "GET /api/v1/organizations" do

    def do_action
      get "/api/v1/organizations.xml"
    end

    it_behaves_like "request invalid content type XML"

    context "valid content type" do
      before do

        get "/api/v1/organizations.json"
      end

      it { expect(response).to be_success }
      it { expect(json["name"]).to eq(organization.name) }
      it { expect(json["uuid"]).to_not be_nil }
    end
  end
end
