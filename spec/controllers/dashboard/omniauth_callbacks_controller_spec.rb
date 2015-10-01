require "spec_helper"

describe Dashboard::OmniauthCallbacksController do
  describe "#facebook" do
    let(:omniauth_response) { OmniAuth.config.mock_auth[:facebook] }

    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = omniauth_response
    end

    def do_action
      get :facebook
    end

    describe "authenticating a new user" do
      it "creates a new user" do
        expect { do_action }.to change(User, :count).by(1)
      end

      it "signs the user in" do
        do_action
        expect(subject.current_user).to be_present
      end

      it "redirects to previous location if present" do
        request.env["omniauth.origin"] = "http://example.org/previous_page"
        do_action
        expect(subject).to redirect_to "http://example.org/previous_page"
      end

      it "redirects to angular app when there is no previous location" do
        do_action
        expect(subject).to redirect_to dashboard_path
      end
    end

    describe "authenticating an user without e-mail" do
      let(:omniauth_response) { OmniAuth.config.mock_auth[:facebook_with_no_email] }

      it "rerequests the user e-mail" do
        expect(do_action).to redirect_to user_omniauth_authorize_path(
          provider: :facebook,
          auth_type: :rerequest,
          scope: :email
        )
      end
    end

    describe "authenticating an existent user" do
      let!(:user) { create(:user, email: "darthvader@example.org") }

      it "does not create a new user" do
        expect { do_action }.to_not change(User, :count)
      end

      it "signs the user in" do
        do_action
        expect(subject.current_user).to eq user
      end
    end
  end
end
