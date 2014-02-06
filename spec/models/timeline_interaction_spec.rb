require 'spec_helper'

describe TimelineInteraction do
  describe "association" do
    it { should belong_to(:timeline) }
    it { should belong_to(:interaction) }
  end
end
