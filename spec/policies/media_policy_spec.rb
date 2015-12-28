require 'spec_helper'
require 'pundit/rspec'

describe MediaPolicy do
  let(:anyone) { create(:profile) }
  let(:author) { create(:profile) }
  let(:student) { create(:profile) }
  let(:moderator) { create(:profile) }
  let(:course) do
    create :course,
           teacher: author,
           students: [student],
           moderators: [moderator]
  end
  let(:topic) do
    create :topic, event: create(:event, course: course)
  end
  let(:media) { create(:media, profile: author, topics: [topic]) }
  let(:another_profile_folder) { create(:folder, course: create(:course)) }
  let(:media_with_another_profile_folder) do
    build(:media, profile: author, folder: another_profile_folder)
  end

  subject { described_class }

  permissions :create? do
    it { is_expected.to permit(anyone, Media.new) }
  end

  permissions :update? do
    it { is_expected.to permit(author, media) }
    it { is_expected.not_to permit(anyone, media) }
    it { is_expected.not_to permit(author, media_with_another_profile_folder) }
  end

  permissions :destroy? do
    it { is_expected.to permit(author, media) }
    it { is_expected.not_to permit(anyone, media) }
  end

  permissions :show? do
    it { is_expected.to permit(author, media) }
    it { is_expected.to permit(student, media) }
    it { is_expected.to permit(moderator, media) }
    it { is_expected.not_to permit(anyone, media) }
  end
end
