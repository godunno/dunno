require "spec_helper"

describe AuthenticateUserFromFacebook do
  describe "logging with facebook" do
    let(:omniauth_hash) do
      OmniAuth.config.mock_auth[:facebook]
    end

    let(:authenticate_with_facebook) do
      AuthenticateUserFromFacebook.new(omniauth_hash).authenticate
    end

    context "as a new user" do
      let(:created_user) { authenticate_with_facebook }

      it { expect(created_user).to be_a User }
      it { expect(created_user.facebook_uid).to eq "12345678" }
      it { expect(created_user.name).to eq "Darth Vader" }
      it { expect(created_user.email).to eq "darthvader@example.org" }
      it { expect(created_user.password).to be_present }
      it { expect(created_user.avatar_url).to eq "http://graph.facebook.com/awesome_photo.png" }
      it { expect(created_user).to be_persisted }
      it { expect(created_user.profile).to be_present }
      it { expect(created_user.profile).to be_persisted }
    end

    context "as an existent user" do
      context "with no previous facebook info" do
        let!(:user) { create(:user, email: "darthvader@example.org") }

        before do
          authenticate_with_facebook
          user.reload
        end

        it { expect(user.facebook_uid).to eq "12345678" }
        it { expect(user.email).to eq "darthvader@example.org" }
        it { expect(user.avatar_url).to eq "http://graph.facebook.com/awesome_photo.png" }
      end
      context "with previous facebook info and a different email address" do
        let!(:user) { create(:user, email: "previous_email@example.org", facebook_uid: "12345678") }

        before do
          authenticate_with_facebook
          user.reload
        end

        it { expect(user.facebook_uid).to eq "12345678" }
        it { expect(user.email).to eq "previous_email@example.org" }
        it { expect(user.avatar_url).to eq "http://graph.facebook.com/awesome_photo.png" }
      end
    end

    context "with an user with no e-mail" do
      let(:omniauth_hash) do
        OmniAuth.config.mock_auth[:facebook_with_no_email]
      end

      it { expect(authenticate_with_facebook).to be false }
    end
  end
end
