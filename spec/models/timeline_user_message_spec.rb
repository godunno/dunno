require 'spec_helper'

describe TimelineUserMessage do
  describe "associations" do
    it { should belong_to(:student) }
  end
  describe "validations" do
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:student) }
  end
end
