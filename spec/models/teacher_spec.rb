require 'spec_helper'

describe Teacher do
  describe "associations" do
    it { should have_and_belong_to_many(:organizations) }
    it { should have_many(:courses) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end
end
