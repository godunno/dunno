require 'spec_helper'

RSpec.describe TrackingEvent, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:trackable) }
    it { is_expected.to belong_to(:course) }
    it { is_expected.to belong_to(:profile) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:trackable) }
    it { is_expected.to validate_presence_of(:course) }
    it { is_expected.to validate_presence_of(:profile) }
  end

  describe "#event_type" do
    it do
      is_expected.to define_enum_for(:event_type)
        .with %w(course_accessed file_downloaded url_clicked comment_created)
    end
  end
end
