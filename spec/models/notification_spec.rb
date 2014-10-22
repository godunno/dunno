require 'spec_helper'

describe Notification do

  let(:notification) { build :notification }

  it "has a valid factory" do
    expect(notification).to be_valid
  end

  describe "associations" do
    it { is_expected.to belong_to(:course) }
  end

  describe "validations" do
    describe "#course" do
      it "should require a course" do
        notification.course = nil
        expect(notification).not_to be_valid
      end
    end

    describe "#message" do
      it "should not allow empty message" do
        notification.message = nil
        expect(notification).not_to be_valid

        notification.message = ''
        expect(notification).not_to be_valid
      end

      it "should not allow a message greater than a SMS" do
        notification.message = 'a' * 161
        expect(notification).not_to be_valid
      end
    end
  end
end
