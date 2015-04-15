require 'spec_helper'

describe TopicForm do
  describe "#update" do
    let(:topic) { create(:topic, description: "One", done: false) }
    let(:update!) { TopicForm.new(topic).update!(topic_params) }

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
