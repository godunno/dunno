require 'spec_helper'

describe Poll do

  let(:poll) { build(:poll) }

  it_behaves_like "artifact"

  describe "associations" do
    it { should belong_to(:event) }
  end

  describe "validations" do
    it { should validate_presence_of(:content) }
    it { should ensure_inclusion_of(:status).in_array(Poll::STATUSES) }
  end

  describe "defaults" do
    its(:status) { should eq("available") }
  end

  describe "callbacks" do

    describe "after create" do

      let!(:uuid) { "ead0077a-842a-4d35-b164-7cf25d610d4d" }

      context "new poll" do
        before(:each) do
          SecureRandom.stub(:uuid).and_return(uuid)
        end

        it "saves a new uuid" do
          expect do
            poll.save!
          end.to change{poll.uuid}.from(nil).to(uuid)
        end
      end
    end
  end

  describe "#release!" do
    before do
      Timecop.freeze
    end

    it { expect {poll.release!}.to change(poll, :status).from("available").to("released") }
    it { expect {poll.release!}.to change(poll, :released_at).from(nil).to(Time.now) }
  end
end
