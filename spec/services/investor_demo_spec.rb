require 'spec_helper'

describe InvestorDemo do
  let(:create_investor) { InvestorDemo.new('Name', 'email@example.com') }
  let(:created_profile) { Profile.last }

  it "creates a user" do
    expect { create_investor }.to change { User.count }.by(1)
  end

  it "creates a profile" do
    expect { create_investor }.to change { Profile.count }.by(1)
  end

  it "creates courses for the profile" do
    expect { create_investor }.to change { Course.count }.by(4)
    expect(Course.last.teacher).to eq created_profile
  end

  it "sends an e-mail" do
    expect { create_investor }
      .to change { ActionMailer::Base.deliveries.size }.by(1)
  end
end
