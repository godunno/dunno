require 'spec_helper'

describe Organizations do
  describe "validations" do
    it { should validate_presence_of(:name) }
  end
end
