require 'spec_helper'

describe Event do

  describe "associations" do
    it { should have_one(:timeline) }
    it { should belong_to(:organization) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:start_at) }
  end

  describe "callbacks" do

    describe "after create" do

      let!(:uuid) { "ead0077a-842a-4d35-b164-7cf25d610d4d" }
      let(:event) { build(:event) }

      context "new event" do
        before(:each) do
          SecureRandom.stub(:uuid).and_return(uuid)
        end

        it "saves a new uuid" do
          expect do
            event.save!
          end.to change{event.uuid}.from(nil).to(uuid)
        end

        it "creates a new timeline" do
          expect do
            event.save!
          end.to change{event.timeline}.from(nil).to(Timeline)
        end
      end

      context "existent event" do
        before(:each) do
          SecureRandom.stub(:uuid).and_return(uuid)
          event.save!
        end

        it "does not saves new uuid" do
          SecureRandom.stub(:uuid).and_return("new-uuid-generate-rencently-7cf25d610d4d")
          expect do
            event.save!
          end.to_not change{ event.uuid }.from(uuid).to("new-uuid-generate-rencently-7cf25d610d4d")
        end
      end
    end
  end
end
