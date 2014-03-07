require 'spec_helper'

describe Poll do
  describe "associations" do
    it { should belong_to(:event) }
  end

  describe "validations" do
    it { should validate_presence_of(:content) }
  end
end
