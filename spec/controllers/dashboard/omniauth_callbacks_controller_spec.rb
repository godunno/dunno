require "spec_helper"

describe Dashboard::OmniauthCallbacksController do
  describe "#facebook" do
    before { stub_env_for_omniauth }
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

  def stub_env_for_omniauth
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end
end
