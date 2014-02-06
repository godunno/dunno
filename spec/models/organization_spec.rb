require 'spec_helper'

describe Organization do

  describe "associations" do
    it { should have_many(:events) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "callbacks" do

    describe "after create" do

      let!(:uuid) { "ead0077a-842a-4d35-b164-7cf25d610d4d" }
      let(:organization) { build(:organization, name: "New school of development")  }

      context "new organization" do
        before(:each) do
          SecureRandom.stub(:uuid).and_return(uuid)
        end

        it "generates an uuid" do
          expect do
            organization.save!
          end.to change{organization.uuid}.from(nil).to(uuid)
        end
      end

      context "existent organization" do
        before(:each) do
          SecureRandom.stub(:uuid).and_return(uuid)
          organization.save!
        end

        it "does not generates an uuid" do
          expect do
            organization.save!
          end.to_not change{organization.uuid}
        end
      end
    end
  end
end
