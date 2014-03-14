require 'spec_helper'

describe PersonalNote do
  describe "associations" do
    it { should belong_to(:event) }
  end
end
