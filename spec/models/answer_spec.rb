require 'spec_helper'

describe Answer do

  describe "associations" do
    it { is_expected.to belong_to(:option) }
    it { is_expected.to belong_to(:student) }
  end

  describe "validations" do

    before do
      poll = create(:poll)
      student = create(:student)
      Answer.create!(option: create(:option, poll: poll), student: student)
      @duplicated_answer = Answer.new(option: create(:option, poll: poll), student: student)
    end

    it { expect(@duplicated_answer).to_not be_valid }

    it "has an error on answer if student is duplicated" do
      @duplicated_answer.valid?
      expect(@duplicated_answer.errors[:student].size).to eq(1)
    end
  end

  describe "#correct?" do
    let(:answer) { build :answer, option: option }

    context "options is correct" do
      let(:option) { build :option, correct: true }
      it { expect(answer).to be_correct }
    end

    context "options is incorrect" do
      let(:option) { build :option, correct: false }
      it { expect(answer).to_not be_correct }
    end
  end
end
