require 'spec_helper'

describe Thermometer do

  let(:thermometer) { build(:thermometer) }

  it_behaves_like "artifact"

  describe "associations" do
    it { is_expected.to have_many(:ratings) }
  end

  describe "validations" do
    [:content].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end

end
