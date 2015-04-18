require 'spec_helper'

describe EventForm do
  describe "#update!" do
    let(:event) { create(:event, status: "draft") }
    let(:update!) { EventForm.new(event, event_params).update! }

    context "successfully updating event" do
      context "updating attributes" do
        context "#status" do
          let(:event_params) { { status: "published" } }

          it do
            expect { update! }
            .to change { event.status }.from("draft").to("published")
          end
        end
      end

      context "reordering #topics" do
        let!(:first_topic) { create :topic, event: event, order: 2 }
        let!(:last_topic) { create :topic, event: event, order: 1 }
        let(:event_params) do
          {
            topics: [last_topic, first_topic].map do |topic|
              topic.attributes.slice("uuid")
            end
          }
        end

        it do
          expect { update! }
          .to change { event.topics(true).to_a }
          .from([first_topic, last_topic]).to([last_topic, first_topic])
        end
      end
    end

    context "failing to update an event" do
      context "with invalid status" do
        let(:event_params) { { status: "brubles" } }

        it { expect { update! }.to raise_error(ArgumentError) }
      end
    end
  end
end
