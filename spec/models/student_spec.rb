require 'spec_helper'

describe Student do
  describe "association" do
    it { should belong_to(:organization) }
  end
end
