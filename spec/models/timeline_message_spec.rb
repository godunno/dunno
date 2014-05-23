require 'spec_helper'

describe TimelineMessage do
  describe "associations" do
    it { should belong_to(:student) }
    it { should have_one(:timeline_interaction) }
    it { should have_one(:timeline).through(:timeline_interaction) }
  end
  describe "validations" do
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:student) }
  end
end
