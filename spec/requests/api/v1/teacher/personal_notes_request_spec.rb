require 'spec_helper'

describe Api::V1::Teacher::PersonalNotesController do
  describe "PATCH /api/v1/teacher/personal_notes/:uuid/transfer" do
    it_behaves_like "API authentication required"
    context "authenticated" do
      let!(:teacher) { create(:teacher) }
      let!(:course) { create(:course, teacher: teacher) }
      let!(:event) { create(:event, course: course, start_at: Time.now) }
      let!(:personal_note) { create(:personal_note, event: event) }

      def do_action
        patch "/api/v1/teacher/personal_notes/#{personal_note.uuid}/transfer.json", auth_params(teacher).to_json
      end

      context "there is a next event" do
        let!(:next_event) { create(:event, course: course, start_at: 1.day.from_now) }

        it "should transfer personal_note to the next event" do
          expect { do_action }.to change{personal_note.reload.event}.
            from(event).to(next_event)
        end
      end

      context "there isn't a next event" do

        it "should return an error" do
          do_action
          expect(last_response.status).to eq(422)
        end
      end
    end
  end
end
