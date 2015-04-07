require 'spec_helper'

describe Topic do

  let(:topic) { build(:topic) }

  describe "associations" do
    it { is_expected.to belong_to(:event).touch(true) }
    it { is_expected.to have_many(:ratings) }
    it { is_expected.to belong_to(:media) }
  end

  describe "validations" do
    it "should have at least description or media" do
      topic = Topic.new
      expect(topic).not_to be_valid
      topic.description = "Some description"
      expect(topic).to be_valid
      topic.description = nil
      topic.media = create(:media)
      expect(topic).to be_valid
    end
  end

  describe "callbacks" do

    describe "after create" do
      context "new topic" do
        it "saves a new uuid" do
          expect(topic.uuid).to be_nil
          topic.save!
          expect(topic.uuid).not_to be_nil
        end
      end
    end
  end

  it "should allow descriptions longer than 255 characters" do
    topic.description = "a" * 256
    expect { topic.save! }.not_to raise_error
  end

  describe "#without_personal" do
    let!(:topic) { create(:topic) }
    let!(:personal_topic) { create(:topic, :personal) }

    it { expect(Topic.without_personal).to eq([topic]) }
  end
end
