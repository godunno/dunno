require 'spec_helper'

describe Rating do
  describe "associations" do
    it { should belong_to(:rateable) }
    it { should belong_to(:student) }
  end

  describe "validations" do

    before do
      thermometer = create(:thermometer)
      student = create(:student)
      Rating.create!(rateable: thermometer, student: student)
      @duplicated_rating = Rating.new(rateable: thermometer, student: student)
    end

    it { expect(@duplicated_rating).to_not be_valid }
    it { expect(@duplicated_rating).to have(1).error_on(:student) }
  end
end
