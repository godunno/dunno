require 'spec_helper'

describe Timeline do

  describe "association" do
    it { should belong_to(:event) }
    it { should have_many(:timeline_interactions) }
  end

  describe "validations" do
    it { should validate_presence_of(:start_at) }
  end
end
