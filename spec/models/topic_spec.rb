require 'spec_helper'

describe Topic do

  let(:topic) { build(:topic) }

  describe "associations" do
    it { is_expected.to have_many(:ratings) }
    it { is_expected.to have_one(:media) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:description) }
  end

  describe "callbacks" do

    describe "after create" do

      let!(:uuid) { "ead0077a-842a-4d35-b164-7cf25d610d4d" }

      context "new topic" do
        before(:each) do
          allow(SecureRandom).to receive(:uuid).and_return(uuid)
        end

        it "saves a new uuid" do
          expect do
            topic.save!
          end.to change{topic.uuid}.from(nil).to(uuid)
        end
      end
    end
  end
end
