require 'spec_helper'

describe Topic do

  let(:topic) { build(:topic) }

  it_behaves_like "artifact"

  describe "associations" do
    it { should have_many(:ratings) }
  end

  describe "validations" do
    it { should validate_presence_of(:description) }
  end

  describe "callbacks" do

    describe "after create" do

      let!(:uuid) { "ead0077a-842a-4d35-b164-7cf25d610d4d" }

      context "new topic" do
        before(:each) do
          SecureRandom.stub(:uuid).and_return(uuid)
        end

        it "saves a new uuid" do
          expect do
            topic.save!
          end.to change{topic.uuid}.from(nil).to(uuid)
        end
      end
    end
  end

  describe "#order" do
    let(:timeline) { create :timeline }
    let(:previous_topic) { build :topic, timeline: timeline }
    let(:topic)          { build :topic, timeline: timeline }
    let(:next_topic)     { build :topic, timeline: timeline }

    before do
      previous_topic.save!
      topic.save!
      next_topic.save!
    end

    it { expect(previous_topic.order).to eq(1) }
    it { expect(topic.order).to eq(2) }
    it { expect(next_topic.order).to eq(3) }

  end
end
