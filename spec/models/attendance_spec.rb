require 'spec_helper'

describe Attendance do
  describe "associations" do
    it { should belong_to(:event) }
    it { should belong_to(:student) }
  end
end
