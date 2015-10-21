require 'spec_helper'

describe TopicsFor do
  let(:teacher) { create(:profile) }
  let(:student) { create(:profile) }
  let(:course) { create(:course, students: [student], teacher: teacher) }
  let(:event) { create(:event, course: course, topics: [topic, personal_topic]) }
  let(:topic) { create(:topic) }
  let(:personal_topic) { create(:topic, :personal) }

  context "as a teacher" do
    let(:topics) { TopicsFor.new(event, teacher).topics }

    it { expect(topics).to eq [topic, personal_topic] }
  end

  context "as a student" do
    let(:topics) { TopicsFor.new(event, student).topics }

    it { expect(topics).to eq [topic] }
  end
end
