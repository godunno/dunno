require 'spec_helper'

describe TimelineUserMessage do

  describe "validations" do
    it { should validate_presence_of(:content) }
  end
end
