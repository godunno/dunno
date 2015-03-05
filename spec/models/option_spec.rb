require 'spec_helper'

describe Option do

  let(:option) { build :option }

  describe "associations" do
    it { is_expected.to belong_to(:poll) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:content) }
  end

  describe "callbacks" do

    describe "after create" do
      context "new option" do
        it "saves a new uuid" do
          expect(option.uuid).to be_nil
          option.save!
          expect(option.uuid).not_to be_nil
        end
      end
    end
  end
end
