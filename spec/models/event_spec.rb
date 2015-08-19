require 'spec_helper'

describe Event do

  let(:event) { build(:event) }

  describe "associations" do
    it { is_expected.to belong_to(:course).touch(true) }
    it { is_expected.to have_many(:topics) }
  end

  describe "validations" do

    %w(start_at end_at course).each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end

  describe "callbacks" do

    describe "after create" do
      context "new event" do
        it "saves a new uuid" do
          expect(event.uuid).to be_nil
          event.save!
          expect(event.uuid).not_to be_nil
        end
      end

      context "existent event" do
        before(:each) do
          event.save!
        end

        it "does not saves new uuid" do
          old_uuid = event.uuid
          event.save!
          expect(event.reload.uuid).to eq(old_uuid)
        end
      end
    end
  end

  describe "indexing" do
    before do
      allow(IndexerWorker).to receive(:perform_async)
    end

    it { expect(Event.index_name).to eq 'test_events' }

    context "creating" do
      it do
        event = create(:event)
        event.run_callbacks(:commit)
        expect(IndexerWorker).to have_received(:perform_async).with("Event", :index, event.id)
      end
    end

    context "updating" do
      let(:event) { create(:event, status: :draft) }

      it do
        event.update!(status: :published)
        event.run_callbacks(:commit)
        expect(IndexerWorker).to have_received(:perform_async).with("Event", :index, event.id)
      end
    end

    context "destroying" do
      let(:event) { create(:event) }

      it do
        event.destroy!
        event.run_callbacks(:commit)
        expect(IndexerWorker).to have_received(:perform_async).with("Event", :delete, event.id)
      end
    end
  end

  describe "#status" do
    %w(draft published canceled).each do |status|

      before do
        event.status = nil
      end

      it { is_expected.to respond_to "#{status}?" }
      it "should be #{status}" do
        expect do
          event.status = status
        end.to change { event.send("#{status}?") }.from(false).to(true)
      end
    end
  end

  describe "#formatted_status" do
    let(:teacher) { create(:profile) }
    let(:student) { create(:profile) }
    let(:course) { create(:course, teacher: teacher, students: [student]) }
    let(:event) { create(:event, course: course) }

    context "it's draft and" do
      before do
        event.status = "draft"
        event.topics = []
      end

      it "there's no topics" do
        expect(event.formatted_status(teacher)).to eq("empty")
      end

      context "there's at least one topic" do
        before do
          event.topics << build(:topic)
        end

        context "as teacher" do
          it { expect(event.reload.formatted_status(teacher)).to eq("draft") }
        end

        context "as student" do
          it { expect(event.reload.formatted_status(student)).to eq("empty") }
        end
      end
    end

    context "it's published and" do
      before do
        event.status = "published"
        event.topics = []
      end

      it "there's no topics" do
        Timecop.freeze(event.end_at - 1.hour) do
          expect(event.formatted_status(teacher)).to eq("published")
        end
      end

      it "it already happened" do
        Timecop.freeze(event.end_at + 1.hour) do
          expect(event.formatted_status(teacher)).to eq("happened")
        end
      end
    end

    context "it's canceled" do
      before do
        event.status = "canceled"
      end

      it { expect(event.formatted_status(teacher)).to eq("canceled") }
    end
  end

  describe "#index_id" do
    let(:event) { create(:event) }
    it { expect(event.index_id).to eq "#{event.course.id}/#{event.start_at.iso8601}" }
  end
end
