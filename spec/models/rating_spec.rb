require 'spec_helper'

describe Rating do
  describe "associations" do
    it { should belong_to(:rateable) }
  end
end
