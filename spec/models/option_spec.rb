require 'spec_helper'

describe Option do
  describe "associations" do
    it { should belong_to(:poll) }
  end

  describe "validations" do
    it { should validate_presence_of(:content) }
  end
end
