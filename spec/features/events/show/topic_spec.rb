require "feature_helper"

describe "Adding a new topic to an event" do
  let!(:user) { create(:user, :teacher_profile) }
  let(:teacher) { user.profile }
  let(:course) { create(:course, teacher: teacher) }
  let!(:event) { create(:event, course: course) }

  before do
    skip
    sign_in(user)
    visit_course(event.course)
    visit_event(event)
  end

  it "shows up in the list after I add it" do
    within("#topics-container") do
      fill_in_and_submit "topic", with: "This is a new topic"
      expect(find("#topics-list")).to have_content "This is a new topic"
    end
  end
end
