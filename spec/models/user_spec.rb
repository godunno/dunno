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

      let!(:uuid) { "ead0077a-842a-4d35-b164-7cf25d610d4d" }

      context "new user" do
        before(:each) do
          allow(SecureRandom).to receive(:uuid).and_return(uuid)
        end

        it "saves a new uuid" do
          expect do
            user.save!
          end.to change{user.uuid}.from(nil).to(uuid)
        end
      end
    end
  end
end
