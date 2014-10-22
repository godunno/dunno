require 'spec_helper'

describe Beacon do

  let(:beacon) { build(:beacon) }

  describe "associations" do
    it { is_expected.to have_many(:events) }
  end

  describe "validations" do
    [:title, :major, :minor].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end

  describe "callbacks" do

    describe "after create" do

      let!(:uuid) { "ead0077a-842a-4d35-b164-7cf25d610d4d" }

      context "new beacon" do
        before(:each) do
          allow(SecureRandom).to receive(:uuid).and_return(uuid)
        end

        it "saves a new uuid" do
          expect do
            beacon.save!
          end.to change { beacon.uuid }.from(nil).to(uuid)
        end
      end

      context "existent beacon" do
        before(:each) do
          allow(SecureRandom).to receive(:uuid).and_return(uuid)
          beacon.save!
        end

        it "does not saves new uuid" do
          allow(SecureRandom).to receive(:uuid).and_return("new-uuid-generate-rencently-7cf25d610d4d")
          expect do
            beacon.save!
          end.to_not change { beacon.uuid }
        end
      end
    end
  end
end
