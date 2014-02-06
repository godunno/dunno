require 'spec_helper'

describe TimelineUserMessage do

  describe "associations" do
    it { should belong_to(:timeline) }
  end

  describe "validations" do
    it { should validate_presence_of(:content) }
  end
end
