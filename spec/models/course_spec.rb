require 'spec_helper'

describe Course do
  describe "associations" do
    it { should belong_to(:teacher) }
    it { should belong_to(:organization) }
    it { should have_many(:events) }
    it { should have_and_belong_to_many(:students) }
  end

  describe "validations" do
    [:teacher].each do |attr|
      it { should validate_presence_of(attr) }
    end
  end
end
