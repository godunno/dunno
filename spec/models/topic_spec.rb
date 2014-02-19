require 'spec_helper'

describe Topic do
  describe "associations" do
    it { should belong_to(:event) }
    it { should have_many(:ratings) }

    it { should validate_presence_of(:description) }
  end
end
