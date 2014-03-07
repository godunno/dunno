require 'spec_helper'

describe Answer do
  describe "associations" do
    it { should belong_to(:option) }
    it { should belong_to(:student) }
  end
end
