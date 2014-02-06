require 'spec_helper'

describe Event do
  describe "associations" do
    it { should have_one(:timeline) }
    it { should belong_to(:organization) }
  end
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:start_at) }
  end
end
