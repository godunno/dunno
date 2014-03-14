require 'spec_helper'

describe Answer do


  describe "associations" do
    it { should belong_to(:option) }
    it { should belong_to(:student) }
  end

  describe "validations" do

    before do
      poll = create(:poll)
      student = create(:student)
      Answer.create!(option: create(:option, poll: poll), student: student)
      @duplicated_answer = Answer.new(option: create(:option, poll: poll), student: student)
    end

    it { expect(@duplicated_answer).to_not be_valid }
    it { expect(@duplicated_answer).to have(1).error_on(:student) }
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
