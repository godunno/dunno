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
          phone_number: user.phone_number,
          password: "PASSWORD",
        }
      }
    end

    def do_action
      post :create, user_hash
    end

    context "succesfully" do

      let(:saved_user) { User.last }

      before do
        allow(TrackerWrapper).to receive_message_chain(:new, :track)
        do_action
      end

      it { is_expected.to respond_with(302) }

      it { expect(User.count).to eq(1) }
      it { expect(saved_user.email).to eq(user.email) }
      it { expect(saved_user.name).to eq(user.name) }
      it { expect(saved_user.phone_number).to eq(user.phone_number) }
    end
  end
end
