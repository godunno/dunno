require 'spec_helper'

describe Api::V1::EventsController do

  describe "GET /api/v1/organizations/1/events" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      let!(:organization) do
        create(:organization)
      end

      let!(:event) { create(:event, title: "New event", organization: organization) }

      let!(:event_from_another_organization) { create(:event) }

      def do_action
        get "/api/v1/organizations/#{organization.id}/events.xml"
      end

      it_behaves_like "request invalid content type XML"

      context "valid content type" do

        context "when receives valid organization id" do

          before(:each) do
            get "/api/v1/organizations/#{organization.id}/events.json"
          end

          it { expect(response).to be_success }
          it { expect(json.length).to eq(1) }
          it { expect(json[0]["title"]).to eq(event.title) }
          it { expect(json[0]["organization_id"]).to eq(organization.id) }
        end

        context "when receives an invalid organization id" do

          it do
            expect { get '/api/v1/organizations/999/events.json' }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end
  end
end
