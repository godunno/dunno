require 'spec_helper'

describe Event do

  let(:event) { build(:event) }

  describe "associations" do
    it { should have_one(:timeline) }
    it { should belong_to(:course) }
    it { should have_many(:topics) }
    it { should have_many(:thermometers) }
    it { should have_many(:personal_notes) }
  end

  describe "defaults" do
    before do
      Timecop.freeze
    end

    its(:start_at) { should eq(DateTime.now) }
  end

  describe "validations" do
    [:title, :start_at, :duration].each do |attr|
      it { should validate_presence_of(attr) }
    end

    it "should validate presence of closed_at only if the event is closed" do
      event.closed_at = nil
      (Event::STATUSES - ["closed"]).each do |status|
        event.status = status
        expect(event).to have(0).error_on(:closed_at)
      end

      event.status = "closed"
      expect(event).to have(1).errors_on(:closed_at)

      event.closed_at = Time.now
      expect(event).to have(0).error_on(:closed_at)
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

        it "creates a new timeline" do
          expect do
            event.save!
          end.to change{event.timeline}.from(nil).to(Timeline)
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

  describe "statuses methods" do
    Event::STATUSES.each do |status|

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

end
