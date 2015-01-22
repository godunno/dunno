require 'spec_helper'

describe Api::V1::UsersController do
  let(:password) { "password" }
  let(:name) { user.name }
  let(:phone_number) { user.phone_number }
  let(:completed_tutorial) { false }
  let(:user) { create(:user, profile: create(:teacher), password: password) }

  let(:user_response_json) do
    {
      "root_path" => "/dashboard/teacher",
      "id" => user.id,
      "name" => name,
      "phone_number" => phone_number,
      "email" => user.email,
      "authentication_token" => user.authentication_token,
      "completed_tutorial" => completed_tutorial,
      "courses" => []
    }
  end

  describe "PATCH /api/v1/users" do
    let(:name) { "Novo nome" }
    let(:phone_number) { "+55 21 12345 6789" }
    let(:completed_tutorial) { true }
    def do_action
      patch "/api/v1/users", params_hash.merge(auth_params(user)).to_json
    end
    before { do_action }

    context "valid update" do
      let(:params_hash) do
        {
          user: {
            name: name,
            phone_number: phone_number,
            completed_tutorial: true
          }
        }
      end

      subject { user.reload }

      it { expect(last_response.status).to eq(200) }
      it { expect(subject.name).to eq(name) }
      it { expect(subject.phone_number).to eq(phone_number) }
      it { expect(subject.completed_tutorial).to eq(true) }

      it { expect(json).to eq(user_response_json) }
    end

    context "updating not allowed fields" do
      let(:email) { "new@email.com" }
      let(:params_hash) do
        {
          user: {
            email: email
          }
        }
      end

      it { expect(user.email).not_to eq(email) }
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

  describe "PATCH /api/v1/users/password" do

    def do_action
      patch "/api/v1/users/password", params_hash.merge(auth_params(user)).to_json
    end
    before { do_action }

    context "updating password" do
      context "successfully" do
        let(:new_password) { "new password" }
        let(:params_hash) do
          {
            user: {
              current_password: password,
              password: new_password,
              password_confirmation: new_password
            }
          }
        end

        it { expect(last_response.status).to eq(200) }
        it { expect(user.reload.valid_password?(new_password)).to eq(true) }
        it { expect(json).to eq(user_response_json) }
      end

      context "unsuccessfully" do
        let(:new_password) { "new password" }
        let(:params_hash) do
          {
            user: {
              password: new_password,
              password_confirmation: new_password
            }
          }
        end

        it { expect(last_response.status).to eq(403) }
        it { expect(user.reload.valid_password?(new_password)).to eq(false) }
        it "should match errors" do
          expect(json).to eq(
            "errors" => {
              "current_password" => ["required"]
            }
          )
        end
      end
    end
  end
end
