require 'spec_helper'

describe CreateTimelineMessage do
  let!(:timeline) { create(:timeline) }
  let!(:student) { create(:student) }
  let(:message_creator) { CreateTimelineMessage.new(attributes) }

  describe "#save", vcr: { match_requests_on: [:method, :host, :path]} do

    context "valid attributes" do
      let!(:attributes) do
        {
          timeline_id: timeline.id,
          student_id: student.id,
          content: "Some message here"
        }
      end

      it "creates a timeline user message" do
        expect do
          message_creator.save!
        end.to change{TimelineUserMessage.count}.from(0).to(1)
      end

      it "creates a timeline interaction" do
        expect do
          message_creator.save!
        end.to change{timeline.timeline_interactions.count}.from(0).to(1)
      end
    end

    context "invalid attributes" do

      context "invalid content" do
        let!(:attributes) do
          {
            timeline_id: timeline.id,
            student_id: student.id,
            content: ""
          }
        end

        it "does not save the timeline user message " do
          expect do
            message_creator.save!
          end.to_not change{TimelineUserMessage.count}.from(0)
        end
      end

      context "invalid timeline id" do
        let!(:attributes) do
          {
            timeline_id: "989898",
            student_id: student.id,
            content: "Some message here"
          }
        end

        it "raises an ActiveRecord::RecordNotFound" do
          expect do
            message_creator.save!
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "invalid student id" do
        let!(:attributes) do
          {
            timeline_id: timeline.id,
            student_id: "989898",
            content: "Some message here"
          }
        end

        it "raises an ActiveRecord::RecordNotFound" do
          expect do
            message_creator.save!
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
