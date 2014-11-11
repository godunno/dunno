require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Keys" do
  let(:json_response) { JSON.parse(response_body) }

  post "/api/v2/keys" do
    let(:user_json) { json_response['user'] }
    parameter :username, 'User e-mail'
    parameter :password, 'User password'
    context "authenticating with username and password" do
      let!(:user) do
        create(:user, email: 'vader@example.com',
              password: 'dunno123', password_confirmation: 'dunno123')
      end

      before { sign_in_with_http_basic(user) }

      example 'Creating an API token for the signed in user', document: :public do
        expect { do_request }.to change { user.api_keys.count }.by(1)
      end

      example_request 'has the user ID' do
        expect(user_json['id']).to eq user.id
      end

      example_request 'has the current token' do
        expect(user_json['token']).to be_present
      end
    end
  end
end
