require 'spec_helper'

describe Teacher do
  describe "associations" do
    it { should have_one(:user) }
    it { should have_and_belong_to_many(:organizations) }
    it { should have_many(:courses) }
  end

  describe "delegation" do
    %w(email authentication_token name phone_number).each do |attribute|
      it { should respond_to(attribute) }
    end
  end
end
