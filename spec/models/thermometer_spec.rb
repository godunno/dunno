require 'spec_helper'

describe Thermometer do
  describe "associations" do
    it { should belong_to(:event) }
    it { should have_many(:ratings) }
  end

  describe "validations" do
    [:content, :event].each do |attr|
      it { should validate_presence_of(attr) }
    end
  end
end
