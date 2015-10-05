require 'spec_helper'
require 'pundit/rspec'

describe AttachmentPolicy do
  let(:anyone) { create(:profile) }
  let(:attachment) { build(:attachment) }

  subject { described_class }

  permissions :create? do
    it { is_expected.to permit(anyone, attachment) }
  end

  permissions :destroy? do
    it { is_expected.not_to permit(anyone, attachment) }
    it { is_expected.to permit(attachment.profile, attachment) }
  end
end
