require 'spec_helper'

describe Teacher do
  describe "associations" do
    it { is_expected.to have_one(:user) }
    it { is_expected.to have_and_belong_to_many(:organizations) }
    it { is_expected.to have_many(:courses) }
  end

  describe "delegation" do
    %w(email authentication_token name phone_number).each do |attribute|
      it { is_expected.to respond_to(attribute) }
    end
  end
end
