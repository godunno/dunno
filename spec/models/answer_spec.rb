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
end
