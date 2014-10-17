require 'spec_helper'

describe Event do


  let(:event) { build(:event) }

  describe "associations" do
    it { should have_one(:timeline) }
    it { should belong_to(:course) }
    it { should have_many(:topics) }
    it { should have_many(:thermometers) }
    it { should have_many(:personal_notes) }
    it { should have_many(:medias) }
    it { should belong_to(:beacon) }
  end

  describe "validations" do

    %w(start_at end_at course).each do |attr|
      it { should validate_presence_of(attr) }
    end
  end

  describe "callbacks" do

    describe "after create" do

      let!(:uuid) { "ead0077a-842a-4d35-b164-7cf25d610d4d" }

      context "new event" do
        before(:each) do
          SecureRandom.stub(:uuid).and_return(uuid)
        end

        it "saves a new uuid" do
          expect do
            event.save!
          end.to change{event.uuid}.from(nil).to(uuid)
        end
      end

      context "existent event" do
        before(:each) do
          SecureRandom.stub(:uuid).and_return(uuid)
          event.save!
        end

        it "does not saves new uuid" do
          SecureRandom.stub(:uuid).and_return("new-uuid-generate-rencently-7cf25d610d4d")
          expect do
            event.save!
          end.to_not change{ event.uuid }.from(uuid).to("new-uuid-generate-rencently-7cf25d610d4d")
        end
      end
    end
  end

  describe "#status" do
    %w(draft published canceled).each do |status|

      before do
        event.status = nil
      end

      it { should respond_to "#{status}?" }
      it "should be #{status}" do
        expect do
          event.status = status
        end.to change{event.send("#{status}?")}.from(false).to(true)
      end
    end
  end

  describe "#formatted_status" do

    before do
      event.save!
    end

    context "it's draft and" do
      before do
        event.status = "draft"
        event.topics = []
        event.personal_notes = []
      end

      it "there's no topics or personal notes" do
        expect(event.formatted_status).to eq("empty")
      end

      it "there's at least one topic" do
        create(:topic, timeline: event.timeline)
        expect(event.formatted_status).to eq("draft")
      end

      it "there's at least one personal note" do
        event.personal_notes << build(:personal_note)
        expect(event.formatted_status).to eq("draft")
      end
    end

    context "it's published and" do
      before do
        event.status = "published"
        event.topics = []
        event.personal_notes = []
      end

      it "there's no topics or personal notes" do
        Timecop.freeze(event.end_at - 1.hour)
        expect(event.formatted_status).to eq("published")
      end

      it "it already happened" do
        Timecop.freeze(event.end_at + 1.hour)
        expect(event.formatted_status).to eq("happened")
      end
    end

    context "it's canceled" do
      before do
        event.status = "canceled"
      end

      it { expect(event.formatted_status).to eq("canceled") }
    end
  end

  describe "#close!" do
    before do
      event.open!
      Timecop.freeze
    end

    it { expect {event.close!}.to change(event, :closed?).from(false).to(true) }
    it { expect {event.close!}.to change(event, :closed_at).from(nil).to(Time.now) }
    it "should not be opened after is closed" do
      event.close!
      expect(event).not_to be_opened
    end
    it "should not be able to close an unopened event" do
      event.opened_at = nil
      expect(event.close!).to be_false
      expect(event).not_to be_closed
    end
  end

  describe "#open!" do
    before do
      Timecop.freeze
    end

    it { expect {event.open!}.to change(event, :opened?).from(false).to(true) }
    it { expect {event.open!}.to change(event, :opened_at).from(nil).to(Time.now) }
    it "should not be closed when it's opened" do
      event.open!
      expect(event).not_to be_closed
    end
  end

  describe "#channel" do
    before do
      event.save!
    end

    it { expect(event.channel).to eq("event_#{event.uuid}") }
  end

  describe "#order" do
    let(:previous_event) do
      build :event,
        course: event.course,
        start_at: event.start_at - 1.day
    end

    let(:next_event) do
      build :event,
        course: event.course,
        start_at: event.start_at + 1.day
    end

    before do
      event.save!
      previous_event.save!
      next_event.save!
    end

    it { expect(previous_event.order).to eq(1) }
    it { expect(event.order).to eq(2) }
    it { expect(next_event.order).to eq(3) }

    describe "#previous" do
      it { expect(event.previous).to eq(previous_event) }

      context "it's the first event" do
        before do
          previous_event.destroy
        end

        it { expect(event.previous).to be_nil }
      end
    end

    describe "#next" do
      it { expect(event.next).to eq(next_event) }

      context "it's the last event" do
        before do
          next_event.destroy
        end

        it { expect(event.next).to be_nil }
      end
    end
  end


end
