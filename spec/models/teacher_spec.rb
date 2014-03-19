require 'spec_helper'

describe Teacher do
  describe "associations" do
    it { should have_and_belong_to_many(:organizations) }
    it { should have_many(:courses) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  describe "callbacks" do
    describe "before save" do
      describe "ensures authentication token" do
        context "when teacher does not have a token" do
          let(:teacher) { build(:teacher) }

          it do
            teacher.save
            expect(teacher.authentication_token).to_not be_nil
          end
        end
        context "when teacher already have a token" do
          let!(:teacher) { create(:teacher) }

          it { expect{ teacher.save }.to_not change{ teacher.reload.authentication_token } }
        end
      end
    end
  end
end
