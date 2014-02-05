require 'spec_helper'

describe Organization do

  describe "associations" do
    it { should have_many(:events) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end
end
