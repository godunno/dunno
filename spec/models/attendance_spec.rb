require 'spec_helper'

describe Attendance do
  describe "associations" do
    it { is_expected.to belong_to(:event) }
    it { is_expected.to belong_to(:student) }
  end
end
