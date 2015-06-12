require 'spec_helper'
require 'pundit/rspec'

describe MediaPolicy do
  let(:anyone) { create(:profile) }
  let(:author) { create(:profile) }
  let(:media) { create(:media, profile: author) }

  subject { described_class }

  permissions :create? do
    it { expect(subject).to permit(anyone, Media.new) }
  end

  permissions :update? do
    it { expect(subject).to permit(author, media) }
    it { expect(subject).not_to permit(anyone, media) }
  end

  permissions :destroy? do
    it { expect(subject).to permit(author, media) }
    it { expect(subject).not_to permit(anyone, media) }
  end
end
