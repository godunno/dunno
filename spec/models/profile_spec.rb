require 'spec_helper'

describe Profile, type: :model do
  subject { build(:profile) }
  it { is_expected.to be_valid }

  describe "associations" do
    it { is_expected.to have_one(:user) }
    it { is_expected.to have_many(:memberships).dependent(:destroy) }
    it { is_expected.to have_many(:courses) }
    it { is_expected.to have_many(:medias).dependent(:destroy) }
  end

  describe "delegation" do
    %w(uuid email authentication_token name).each do |attribute|
      it { is_expected.to respond_to(attribute) }
    end
  end

  describe "validations" do
    describe "#courses" do
      let(:profile) { create(:profile) }
      let(:course) { create(:course) }

      it "doesn't allow associate as student to the same course more than once" do
        expect { course.students << profile }.not_to raise_error
        expect { course.students << profile }.to raise_error
      end

      it "doesn't allow associate as both student and teacher to the same course" do
        expect { course.students << profile }.not_to raise_error
        expect { course.teacher = profile }.to raise_error
      end
    end
  end

  describe "#role_in" do
    let(:course) { create(:course, teacher: teacher, students: [student]) }
    let(:teacher) { create(:profile) }
    let(:student) { create(:profile) }
    let(:other_profile) { create(:profile) }

    it { expect(teacher.role_in(course)).to eq('teacher') }
    it { expect(student.role_in(course)).to eq('student') }
    it { expect(other_profile.role_in(course)).to be false }
  end

  describe "has_course?" do
    let(:course) { create(:course, teacher: teacher, students: [student]) }
    let(:teacher) { create(:profile) }
    let(:student) { create(:profile) }
    let(:another_profile) { create(:profile) }

    it { expect(teacher).to have_course(course) }
    it { expect(student).to have_course(course) }
    it { expect(another_profile).to_not have_course(course) }
  end

  describe "#students_count" do
    let!(:course) { create(:course, teacher: teacher, students: [student]) }
    let!(:other_course) { create(:course, teacher: teacher, students: [student, another_student]) }
    let!(:teacher) { create(:profile) }
    let!(:student) { create(:profile) }
    let!(:another_student) { create(:profile) }

    it { expect(teacher.students_count).to eq 2 }
    it { expect(student.students_count).to eq 0 }
  end

  describe "#notifications_count" do
    let!(:course) { create(:course, teacher: teacher, students: [student, another_student]) }
    let!(:teacher) { create(:profile) }
    let!(:student) { create(:profile) }
    let!(:another_student) { create(:profile) }

    before do
      SendNotification.new(course: course, message: "test").call
    end

    pending { expect(teacher.notifications_count).to eq 2 }
    it { expect(student.notifications_count).to eq 0 }
  end

  describe "#create_course!" do
    let!(:profile) { create(:profile) }
    let(:created_course) { Course.last }

    it "creates a course belonging to this profile as teacher" do
      profile.create_course!(attributes_for(:course))
      expect(created_course.teacher).to eq profile
    end

    it "will ignore another profile being passed as teacher" do
      profile.create_course!(attributes_for(:course, teacher: create(:profile)))
      expect(created_course.teacher).to eq profile
    end

    it "will raise an error if no attributes are sent" do
      expect { profile.create_course!({}) }
        .to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
