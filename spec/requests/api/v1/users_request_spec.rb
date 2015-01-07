require 'spec_helper'

describe Api::V1::UsersController do
  describe "PATCH /api/v1/users" do
    let(:user) { create(:user, profile: create(:teacher)) }
    let(:name) { "Novo nome" }
    let(:phone_number) { "+55 21 12345 6789" }
    def do_action
      patch "/api/v1/users", params_hash.merge(auth_params(user)).to_json
    end
    before { do_action }

    context "valid update" do
      let(:params_hash) do
        {
          user: {
            name: name,
            phone_number: phone_number
          }
        }
      end

      subject { user.reload }

      it { expect(last_response.status).to eq(200) }
      it { expect(subject.name).to eq(name) }
      it { expect(subject.phone_number).to eq(phone_number) }

      it "should match the json" do
        expect(json).to eq(
          "root_path" => "/dashboard/teacher",
          "id" => user.id,
          "name" => name,
          "phone_number" => phone_number,
          "email" => user.email,
          "authentication_token" => user.authentication_token,
          "courses" => []
        )
      end
    end

    context "updating not allowed fields" do
      let(:params_hash) do
        {
          user: {
            password: "New password"
          }
        }
      end

      it { expect(user.password).to eq(user.reload.password) }
    end

    context "invalid update" do
      let(:params_hash) do
        {
          user: {
            name: ''
          }
        }
      end

      it { expect(last_response.status).to eq(403) }
    end

    context "trying to update another user's profile" do
      let(:another_user) { create(:user) }
      let(:params_hash) do
        {
          user: {
            id: another_user.id,
            name: name
          }
        }
      end

      it { expect(another_user.reload.name).not_to eq(name) }
      it { expect(user.reload.name).to eq(name) }
    end
  end
end
