require 'spec_helper'

describe Poll do

  let(:poll) { build(:poll) }

  it_behaves_like "artifact"

  describe "associations" do
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_inclusion_of(:status).in_array(Poll::STATUSES) }
  end

  describe "defaults" do
    it { expect(subject.status).to eq "available" }
  end

  describe "callbacks" do

    describe "after create" do
      context "new poll" do
        it "saves a new uuid" do
          expect(poll.uuid).to be_nil
          poll.save!
          expect(poll.uuid).not_to be_nil
        end
      end
    end
  end

  describe "#release!" do
    before do
      Timecop.freeze
    end
    after { Timecop.return }

    it { expect {poll.release!}.to change(poll, :status).from("available").to("released") }
    it { expect {poll.release!}.to change(poll, :released_at).from(nil).to(Time.now) }
  end
end
