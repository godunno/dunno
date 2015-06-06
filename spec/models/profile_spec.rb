require 'spec_helper'

describe Profile, type: :model do
  subject { build(:profile) }
  it { is_expected.to be_valid }

  describe "associations" do
    it { is_expected.to have_one(:user) }
    it { is_expected.to have_many(:memberships) }
    it { is_expected.to have_many(:courses) }
    it { is_expected.to have_many(:medias) }
  end

  describe "delegation" do
    %w(uuid email authentication_token name phone_number).each do |attribute|
      it { is_expected.to respond_to(attribute) }
    end
  end

  describe "validations" do

    describe "#courses" do
      let(:profile) { create(:profile) }
      let(:course) { create(:course) }

      it "doesn't allow associate as student to the same course more than once" do
        expect{course.students << profile}.not_to raise_error
        expect{course.students << profile}.to raise_error
      end

      it "doesn't allow associate as both student and teacher to the same course" do
        expect{course.students << profile}.not_to raise_error
        expect{course.teacher = profile}.to raise_error
      end
    end
  end

  describe "#role_in" do
    let(:course) { create(:course, teacher: teacher, students: [student]) }
    let(:teacher) { create(:profile) }
    let(:student) { create(:profile) }

    it { expect(teacher.role_in(course)).to eq('teacher') }
    it { expect(student.role_in(course)).to eq('student') }
  end
end
