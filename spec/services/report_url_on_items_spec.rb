require 'spec_helper'

describe ReportUrlOnItems do
  before do
    teacher = create :profile
    2.times { create :topic, event: create(:event, course: create(:course, teacher: teacher)), description: "The URL http://example.com is a test." }
    create :topic, description: nil, media: create(:media)
  end

  subject { ReportUrlOnItems.new(Topic) }

  it { expect(subject.with_url.count).to eq(2) }
  it { expect(subject.teachers_using_url.count).to eq(1) }
end
