require 'spec_helper'

RSpec.describe Folder, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:course) }
    it { is_expected.to have_many(:medias) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:course) }
  end
end
