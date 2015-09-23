require 'spec_helper'

describe Dashboard::UsersController do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  let(:user) { build :user }

  describe "POST /users" do
    let(:user_hash) do
      {
        user: {
          email: user.email,
          name: user.name,
          password: "PASSWORD"
        }
      }
    end

    def do_action
      post :create, user_hash.merge(format: :json)
    end

    context "succesfully" do
      let(:saved_user) { User.last }

      before do
        allow(TrackerWrapper).to receive_message_chain(:new, :track)
        do_action
      end

      it { is_expected.to respond_with(201) }

      it { expect(User.count).to eq(1) }
      it { expect(saved_user.email).to eq(user.email) }
      it { expect(saved_user.name).to eq(user.name) }
    end

    context "email already taken" do
      let!(:previous_user) { create(:user, email: user.email) }

      before do
        do_action
      end

      it "returns an error for email taken" do
        expect(JSON.parse response.body).to eq(
          "errors" => {
            "email" => ["taken"]
          }
        )
      end
    end
  end
end
