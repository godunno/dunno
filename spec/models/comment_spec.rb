require 'spec_helper'

RSpec.describe Comment, type: :model do
  describe "associations" do
    it { is_expected.to belong_to :profile }
    it { is_expected.to belong_to :event }
  end
end
