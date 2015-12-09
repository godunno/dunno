require 'spec_helper'

describe Profile, type: :model do
  subject { build(:profile) }
  it { is_expected.to be_valid }

  describe "associations" do
    it { is_expected.to have_one(:user) }
    it { is_expected.to have_many(:memberships).dependent(:destroy) }
    it { is_expected.to have_many(:courses) }
    it { is_expected.to have_many(:medias).dependent(:destroy) }
    it { is_expected.to have_many(:system_notifications).dependent(:destroy) }
    it { is_expected.to have_many(:tracking_events).dependent(:destroy) }
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
        expect { course.students << profile }.to raise_error(ActiveRecord::RecordNotUnique)
      end

      it "doesn't allow associate as both student and teacher to the same course" do
        expect { course.students << profile }.not_to raise_error
        expect { course.teacher = profile }.to raise_error(ActiveRecord::RecordNotUnique)
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

  describe "#block_in!" do
    let(:course) { create(:course, teacher: teacher, students: [student]) }
    let(:teacher) { create(:profile) }
    let(:student) { create(:profile) }
    let(:other_profile) { create(:profile) }

    it do
      student.block_in!(course)
      expect(student.blocked_in?(course)).to be true
    end

    it do
      expect { teacher.block_in!(course) }.to raise_error(ActiveRecord::RecordInvalid)
      expect(teacher.blocked_in?(course)).to be false
    end

    it do
      expect { other_profile.block_in!(course) }.to raise_error(ActiveRecord::RecordNotFound)
      expect(other_profile.blocked_in?(course)).to be nil
    end
  end

  describe "#unblock_in!" do
    let(:course) { create(:course, teacher: teacher, students: [blocked_student]) }
    let(:teacher) { create(:profile) }
    let(:blocked_student) { create(:profile) }
    let(:other_profile) { create(:profile) }

    before do
      blocked_student.block_in!(course)
    end

    it do
      blocked_student.unblock_in!(course)
      expect(blocked_student.blocked_in?(course)).to be false
    end

    it do
      expect { teacher.unblock_in!(course) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it do
      expect { other_profile.unblock_in!(course) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "#courses" do
    let(:student) { create(:profile) }
    let(:course) { create(:course, students: [student]) }
    it "doesn't show blocked courses" do
      student.block_in!(course)
      expect(student.courses).to eq []
      expect(student.courses_with_blocked).to eq [course]
    end
  end

  describe "#last_digest_sent_at" do
    before { Timecop.freeze }
    after { Timecop.return }

    it "sets the attribute to the current time" do
      profile = Profile.create!
      expect(profile.last_digest_sent_at).to eq Time.current
    end
  end
end
