require 'spec_helper'

describe User do
  let(:user) { build :user }
  it { expect(user).to be_valid }

  describe "association" do
    it { is_expected.to belong_to(:profile) }
    it { is_expected.to have_many(:api_keys) }
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
end
