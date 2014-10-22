require 'spec_helper'

describe TimelineInteraction do
  describe "association" do
    it { is_expected.to belong_to(:timeline) }
    it { is_expected.to belong_to(:interaction) }
  end
end
