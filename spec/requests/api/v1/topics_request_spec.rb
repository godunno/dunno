require 'spec_helper'

describe Api::V1::TopicsController do
  let!(:weekly_schedule) { create(:weekly_schedule, weekday: 1, start_time: '09:00', end_time: '11:00') }
  let!(:teacher) { create(:profile) }
  let!(:course) { create(:course, teacher: teacher, weekly_schedules: [weekly_schedule]) }
  let!(:event) { create(:event, course: course, start_at: Time.zone.local(2015, 7, 20, 9)) }

  describe "POST /api/v1/topics" do
    def do_action
      post "/api/v1/topics.json", topic_params.merge(auth_params(teacher)).to_json
    end

    context "successfully creating" do
      let(:topic_params) do
        {
          topic: {
            description: "One",
            personal: true,
            event: {
              course: {
                uuid: course.uuid
              },
              start_at: event.start_at.utc.iso8601
            }
          }
        }
      end
      let(:new_topic) { event.topics.last }

      it do
        do_action
        expect(last_response.status).to eq(201)
      end

      it do
        expect { do_action }
        .to change { event.topics.count }.by(1)
      end

      it do
        do_action
        expect(json).to eq(
          "description" => "One",
          "done" => false,
          "media_id" => nil,
          "personal" => true,
          "uuid" => new_topic.uuid
        )
      end

      context "with media" do
        let(:media) { create(:media) }
        let(:topic_params) do
          {
            topic: {
              description: "One",
              media_id: media.id,
              event: {
                course: {
                  uuid: course.uuid
                },
                start_at: event.start_at.utc.iso8601
              }
            }
          }
        end

        it do
          do_action
          expect(json).to eq(
            "description" => "One",
            "done" => false,
            "media_id" => media.id,
            "media"=>{
            "id" => media.id,
            "uuid" => media.uuid,
            "title" => "One",
            "description" => nil,
            "category" => nil,
            "preview" => nil,
            "type" => nil,
            "thumbnail" => nil,
            "filename" => nil,
            "tag_list" => [],
            "url" => nil
          },
            "personal" => false,
            "uuid" => new_topic.uuid
          )
        end
      end

      context "generating order" do
        let!(:first_topic) { create(:topic, event: event, order: 2) }

        it do
          do_action
          created_topic = Topic.find_by!(uuid: json["uuid"])
          expect(created_topic.order).to eq(3)
        end
      end

      context "when the event isn't still persisted" do
        let(:new_course) { create(:course, teacher: teacher, weekly_schedules: [weekly_schedule]) }
        let!(:weekly_schedule) { create(:weekly_schedule, weekday: 1, start_time: '09:00', end_time: '11:00') }
        let(:start_at) { Time.zone.local(2015, 07, 20, 9) }
        let(:topic_params) do
          {
            topic: {
              description: "One",
              event: {
                course: {
                  uuid: new_course.uuid
                },
                start_at: start_at.utc.iso8601
              }
            }
          }
        end

        before { do_action }

        subject { Topic.last }

        it { expect(subject.description).to eq "One" }
        it { expect(subject.event.start_at.change(usec: 0)).to eq start_at.change(usec: 0) }
        it { expect(subject.event.end_at.change(usec: 0)).to eq (start_at.change(usec: 0) + 2.hours) }
        it { expect(subject.event.course).to eq new_course }
        pending "must save the event with classroom and end_at"
      end
    end

    context "failing to create" do
      context "without description" do
        let(:topic_params) do
          {
            topic: {
              description: '',
              event: {
                course: {
                  uuid: course.uuid
                },
                start_at: event.start_at.utc.iso8601
              }
            }
          }
        end

        it do
          do_action
          expect(last_response.status).to eq(422)
        end

        it do
          expect { do_action }
          .not_to change { event.topics.count }
        end

        it do
          do_action
          expect(json).to eq(
            "errors" => {
              "description" => [{ "error" => "blank_content" }],
              "media" => [{ "error" => "blank_content" }]
            }
          )
        end
      end

      context "without event" do
        let(:topic_params) do
          {
            topic: {
              description: "One",
              event: {}
            }
          }
        end

        it do
          expect { do_action }.to raise_error(ActionController::ParameterMissing)
        end
      end

      context "with event from another user" do
        let(:event_from_another_user) { create(:event) }
        let(:topic_params) do
          {
            topic: {
              description: "One",
              event: {
                course: {
                  uuid: event_from_another_user.course.uuid
                },
                start_at: event_from_another_user.start_at.utc.iso8601
              }
            }
          }
        end

        it do
          expect { do_action }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe "PATCH /api/v1/topics/:uuid" do

    def do_action
      patch "/api/v1/topics/#{topic.uuid}.json", topic_params.merge(auth_params(teacher)).to_json
    end

    context "successfuly updating" do
      describe "#description" do
        let(:topic) { create(:topic, event: event, description: "One") }
        let(:topic_params) { { topic: { description: "Other" } } }

        it do
          expect { do_action }
          .to change { topic.reload.description }.from("One").to("Other")
        end

        it do
          do_action
          expect(json).to eq(
            "uuid" => topic.uuid,
            "done" => false,
            "personal" => false,
            "description" => "Other",
            "media_id" => nil
          )
        end
      end

      describe "#done" do
        let(:topic) { create(:topic, event: event, done: true) }
        let(:topic_params) { { topic: { done: false } } }

        it do
          expect { do_action }
          .to change { topic.reload.done }.from(true).to(false)
        end
      end

      describe "#personal" do
        let(:topic) { create(:topic, event: event, personal: true) }
        let(:topic_params) { { topic: { personal: false } } }

        it do
          expect { do_action }
          .to change { topic.reload.personal }.from(true).to(false)
        end
      end

      describe "media's description" do
        let(:media) { create(:media, title: "One") }
        let(:topic) { create(:topic, event: event, media: media) }
        let(:topic_params) { { topic: { description: "Other", media_id: media.uuid } } }

        it do
          expect { do_action }
          .to change { media.reload.title }.from("One").to("Other")
        end
      end
    end

    context "failing to update" do
      let!(:topic) { create(:topic, event: event) }
      let(:topic_params) { { topic: { description: nil } } }
      before { do_action }
      it { expect(last_response.status).to eq(422) }
      it do
        expect(json).to eq(
          "errors" => {
            "description" => [{ "error" => "blank_content" }],
            "media" => [{ "error" => "blank_content" }]
          }
        )
      end
    end
  end

  describe "DELETE /api/v1/topics/:uuid" do
    let!(:topic) { create(:topic, event: event) }
    def do_action
      delete "/api/v1/topics/#{topic.uuid}.json", auth_params(teacher).to_json
    end

    it do
      expect { do_action }
      .to change { Topic.count }.from(1).to(0)
    end
  end

  describe "PATCH /api/v1/topics/:uuid/transfer" do
    let!(:topic) { create(:topic, event: event) }
    context "authenticated" do
      def do_action
        patch "/api/v1/topics/#{topic.uuid}/transfer.json", auth_params(teacher).to_json
      end

      context "there is a next event" do
        let(:next_event) { create(:event, course: course, start_at: 1.day.from_now) }

        before do
          navigation = double('EventNavigation', next: next_event)
          allow(EventNavigation).to receive(:new).with(event).and_return(navigation)
        end

        it "should transfer topic to the next event" do
          expect { do_action }.to change { topic.reload.event }
          .from(event).to(next_event)
        end
      end

      context "there isn't a next event" do
        before do
          navigation = double('EventNavigation', next: nil)
          allow(EventNavigation).to receive(:new).with(event).and_return(navigation)
        end

        it "should return an error" do
          do_action
          expect(last_response.status).to eq(422)
        end
      end
    end
  end
end
