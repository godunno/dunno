require 'spec_helper'

describe Api::V1::Teacher::TopicsController do
  let!(:teacher) { create(:teacher) }
  let!(:course) { create(:course, teacher: teacher) }
  let!(:event) { create(:event, course: course, start_at: Time.now) }

  describe "PATCH /api/v1/teacher/topics/:uuid" do

    def do_action
      patch "/api/v1/teacher/topics/#{topic.uuid}.json", topic_params.merge(auth_params(teacher)).to_json
    end

    context "successfuly updating" do
      describe "#description" do
        let!(:topic) { create(:topic, description: "One") }
        let(:topic_params) { { topic: { description: "Other" } } }

        it do
          expect { do_action }
          .to change { topic.reload.description }.from("One").to("Other")
        end

        it do
          do_action
          expect(json).to eq(
            "uuid" => topic.uuid,
            "order" => nil,
            "done" => false,
            "personal" => false,
            "description" => "Other",
            "media_id" => nil
          )
        end
      end

      describe "#done" do
        let!(:topic) { create(:topic, done: true) }
        let(:topic_params) { { topic: { done: false } } }

        it do
          expect { do_action }
          .to change { topic.reload.done }.from(true).to(false)
        end
      end
    end

    context "failing to update" do
      let!(:topic) { create(:topic) }
      let(:topic_params) { { topic: { description: nil } } }
      before { do_action }
      it { expect(last_response.status).to eq(422) }
      it do
        expect(json).to eq(
          "errors" => {
            "description" => [{ "error" => "blank" }]
          }
        )
      end
    end
  end

  describe "DELETE /api/v1/teacher/topics/:uuid" do
    let!(:topic) { create(:topic) }
    def do_action
      delete "/api/v1/teacher/topics/#{topic.uuid}.json", auth_params(teacher).to_json
    end

    it do
      expect { do_action }
      .to change { Topic.count }.from(1).to(0)
    end
  end

  describe "PATCH /api/v1/teacher/topics/:uuid/transfer" do
    let!(:topic) { create(:topic, event: event) }
    context "authenticated" do
      def do_action
        patch "/api/v1/teacher/topics/#{topic.uuid}/transfer.json", auth_params(teacher).to_json
      end

      context "there is a next event" do
        let!(:next_event) { create(:event, course: course, start_at: 1.day.from_now) }

        it "should transfer topic to the next event" do
          expect { do_action }.to change { topic.reload.event }
          .from(event).to(next_event)
        end
      end

      context "there isn't a next event" do

        it "should return an error" do
          do_action
          expect(last_response.status).to eq(422)
        end
      end

      # TODO: move to model spec
      context "next event is canceled" do
        let!(:canceled_event) { create(:event, course: course, start_at: 1.day.from_now, status: :canceled) }
        let!(:next_event) { create(:event, course: course, start_at: 2.day.from_now) }

        it "should transfer topic to the next event" do
          expect { do_action }.to change { topic.reload.event }
          .from(event).to(next_event)
        end
      end
    end
  end
end
