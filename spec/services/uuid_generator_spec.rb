require 'spec_helper'

describe UuidGenerator do

  let!(:organization) { create(:organization) }
  let!(:uuid_generator) { UuidGenerator.new(organization) }

  describe "#generate!" do
    let!(:uuid) { "ead0077a-842a-4d35-b164-7cf25d610d4d" }

    context "when SecureRandom.uuid generates an existent uuid" do
      before(:each) do
        uuid_generator.generate!
      end

      it "generates a different one and save" do
        existent_uuid = organization.uuid
        SecureRandom.stub(:uuid).and_return(uuid)
        expect do
          uuid_generator.generate!
        end.to change{organization.uuid}.from(existent_uuid).to(uuid)
      end
    end

    context "when SecureRandom.uuid generates a not existent uuid" do

      it "saves on organization uuid" do
        SecureRandom.stub(:uuid).and_return(uuid)
        expect do
          uuid_generator.generate!
        end.to change{organization.uuid}.from(nil).to(uuid)
      end
    end
  end
end