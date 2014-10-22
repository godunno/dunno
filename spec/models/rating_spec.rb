require 'spec_helper'

describe Rating do
  describe "associations" do
    it { is_expected.to belong_to(:rateable) }
    it { is_expected.to belong_to(:student) }
  end

  describe "validations" do

    before do
      thermometer = create(:thermometer)
      student = create(:student)
      Rating.create!(rateable: thermometer, student: student)
      @duplicated_rating = Rating.new(rateable: thermometer, student: student)
    end

    it { expect(@duplicated_rating).to_not be_valid }

    it 'has an error on student' do
      @duplicated_rating.valid?
      expect(@duplicated_rating.errors[:student].size).to eq 1
    end
  end
end
