require 'spec_helper'

describe Student do

  let(:student) { build :student }

  it { expect(student).to be_valid }

  describe "association" do
    it { should have_one(:user) }
    it { should have_many(:events) }
    it { should have_and_belong_to_many(:courses) }
  end

  describe "delegation" do
    %w(email authentication_token name phone_number).each do |attribute|
      it { should respond_to(attribute) }
    end
  end

  describe "validations" do

    describe "#courses" do

      let(:course) { create :course }

      before do
        student.save!
      end

      it "should not allow associate to the same course more than once" do
        expect{course.students << student}.not_to raise_error
        expect{course.students << student}.to raise_error
      end
    end
  end
end
