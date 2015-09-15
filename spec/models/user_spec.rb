require 'spec_helper'

describe User do
  let(:user) { build :user }
  it { expect(user).to be_valid }

  describe "association" do
    it { is_expected.to belong_to(:profile).dependent(:destroy) }
    it { is_expected.to have_many(:api_keys).dependent(:destroy) }
  end

  describe "validations" do
    [:name, :email, :phone_number, :password].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end

  describe "callbacks" do
    describe "before save" do
      describe "ensures authentication token" do
        context "when user does not have a token" do
          let(:user) { build(:user) }

          it do
            user.save
            expect(user.authentication_token).to_not be_nil
          end
        end
        context "when user already have a token" do
          let!(:user) { create(:user) }

          it { expect{ user.save }.to_not change{ user.reload.authentication_token } }
        end
      end
    end

    describe "after create" do
      context "new user" do
        it "saves a new uuid" do
          expect(user.uuid).to be_nil
          user.save!
          expect(user.uuid).not_to be_nil
        end
      end
    end
  end

  describe "#profile_name" do
    it "has the role of teacher in a course" do
      user.profile = create(:profile)
      create(:course, teacher: user.profile)
      expect(user.profile_name).to eq('teacher')
    end

    it "doesn't have the role of teacher in any course" do
      user.profile = create(:profile)
      expect(user.profile_name).to eq('student')
    end
  end

  describe "tracking" do
    let(:user) { create(:user) }

    it "tracks password reset notifications" do
      expect(user).to receive(:track).with('Reset Password Requested')
      user.send_reset_password_instructions
    end

    it "tracks password successfully changed" do
      expect(user).to receive(:track).with('Password Changed', page: "Password Recovery")
      user.reset_password("#dunnovc", "#dunnovc")
    end
  end
end
