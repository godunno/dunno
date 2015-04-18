require 'spec_helper'

describe TopicForm do
  describe "#create!" do
    let(:topic) { Topic.new }
    let(:event) { create(:event) }
    let(:create!) { TopicForm.new(topic, topic_params).create!(event.reload) }

    context "successfully creating topic" do
      context "with description" do
        let(:topic_params) do
          {
            description: "One"
          }
        end

        it { expect { create! }.to change { topic.description }.from(nil).to("One") }

        context "with media" do
          let(:media) { create(:media, title: "One") }
          let(:topic_params) do
            {
              description: "Another",
              media_id: media.id
            }
          end

          it { expect { create! }.to change { topic.media }.from(nil).to(media) }
          it { expect { create! }.to change { media.reload.title }.from("One").to("Another") }
        end
      end

      context "defining order" do
        let!(:another_topic) { create(:topic, event: event, order: 2) }
        let(:topic_params) do
          {
            description: "One"
          }
        end

        it { expect { create! }.to change { topic.order }.from(nil).to(3) }
      end
    end

    context "failing to create a topic" do
      let(:topic_params) { { description: "" } }

      context "with an empty description" do
        it { expect { create! }.to raise_error(ActiveRecord::RecordInvalid) }
      end
    end
  end

  describe "#update!" do
    let(:topic) { create(:topic, description: "One", done: false) }
    let(:update!) { TopicForm.new(topic, topic_params).update! }

    context "successfully updating topic" do
      context "with a description" do
        let(:topic_params) do
          {
            description: "Another",
            done: true
          }
        end

        it { expect { update! }.to change { topic.description }.from("One").to("Another") }
        it { expect { update! }.to change { topic.done }.from(false).to(true) }
      end

      context "with a media attached to it" do
        let(:media) { create(:media, title: "One") }
        let(:topic) { create(:topic, description: nil, media: media) }

        let(:topic_params) do
          {
            description: "Another"
          }
        end

        it { expect { update! }.to change { media.title }.from("One").to("Another") }

        context "changing done value" do
          let(:topic_params) do
            {
              description: "Another",
              done: true
            }
          end

          it { expect { update! }.to change { topic.done }.from(false).to(true) }
        end
      end
    end

    context "failing to update a topic" do
      let(:topic_params) { { description: "" } }

      context "with an empty description" do
        it { expect { update! }.to raise_error(ActiveRecord::RecordInvalid) }

        context "with a media attached to it" do
          let(:media) { create(:media, title: "One") }
          let(:topic) { create(:topic, description: nil, media: media) }

          it { expect { update! }.to raise_error(ActiveRecord::RecordInvalid) }
        end
      end
    end
  end
end
