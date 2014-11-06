require 'spec_helper'

describe ApiKey do
  subject { create(:api_key) }

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:token) }
    it { is_expected.to validate_presence_of(:user) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
  end

  it 'generates a token on create' do
    key = build(:api_key)
    key.save!
    expect(key.token).to_not be_nil
  end
end
