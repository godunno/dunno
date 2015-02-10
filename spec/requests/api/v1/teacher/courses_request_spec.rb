require 'spec_helper'

describe Api::V1::Teacher::EventsController do

  let!(:teacher) { create :teacher }
  let(:organization) { create :organization }
  let(:student) { create :student }
  let(:course) { build :course, teacher: teacher, organization: organization, students: [student] }

  def last_course
    Course.order('created_at desc').first
  end

  let(:parameters) do
    params = {course: {}}
    %w(name start_date end_date class_name grade institution organization_id).each do |attr|
      params[:course][attr] = course.send(attr)
    end
    params
  end

  describe "GET /api/v1/teacher/courses.json" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      def do_action
        get "/api/v1/teacher/courses.json", auth_params(teacher)
      end

      let!(:course_from_another_teacher) { create(:course, teacher: create(:teacher)) }

      before do
        course.save!
        do_action
      end

      describe "collection" do

        subject { json.map {|course| course["uuid"]} }

        it { expect(subject).to include course.uuid }
        it { expect(subject).not_to include course_from_another_teacher.uuid }

        describe "course" do
          subject { json[0] }
          it { expect(subject["students_count"]).to eq(1) }
        end
      end
    end
  end

  describe "GET /api/v1/teacher/courses/:uuid.json" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      let!(:event) { create(:event, course: course) }
      let!(:event_from_another_teacher) { create(:event, course: create(:course, teacher: create(:teacher))) }
      let!(:event_from_another_course) { create(:event, course: create(:course, teacher: teacher)) }

      before do
        course.save!
        do_action
      end

      def do_action
        get "/api/v1/teacher/courses/#{course.uuid}.json", auth_params(teacher)
      end

      context "teacher's course" do

        describe "resource" do
          subject { json["course"] }
          it { expect(subject["uuid"]).to eq course.uuid }

          skip "course's attributes"
          it { expect(subject["order"]).to eq course.order }
          it { expect(subject["access_code"]).to eq course.access_code }
          it { expect(subject["students_count"]).to eq 1 }
          it { expect(subject["color"]).to eq(SHARED_CONFIG["v1"]["courses"]["schemes"][course.order]) }
          it { expect(subject["students"][0]["name"]).to eq(student.name) }

          describe "course's events" do
            subject { json["course"]["events"].map {|e| e["uuid"]} }
            it { expect(subject).to include event.uuid }
            it { expect(subject).not_to include event_from_another_teacher.uuid }
            it { expect(subject).not_to include event_from_another_course.uuid }
          end
        end
      end

      context "another teacher's course" do
        let!(:course) { create(:course, teacher: create(:teacher)) }
        it { expect(last_response.status).to eq 404 }
      end
    end
  end

  describe "GET /api/v1/teacher/courses/:uuid/students.json" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      before do
        course.save!
        do_action
      end

      def do_action
        get "/api/v1/teacher/courses/#{course.uuid}/students.json", auth_params(teacher)
      end

      describe "students" do
        let(:target) { student }
        subject { json[0] }
        it_behaves_like "request return check", %w(uuid name email avatar)
      end

    end
  end

  describe "POST /api/v1/teacher/courses.json" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      def do_action
        post "/api/v1/teacher/courses.json", parameters.merge(auth_params(teacher)).to_json
      end

      it "should schedule it's events" do
        course_scheduler = double("course_scheduler")
        expect(CourseScheduler)
          .to receive(:new)
          .and_return(course_scheduler)
        expect(course_scheduler).to receive(:schedule!)
        do_action
      end

      context "creating the course" do
        before do
          do_action
        end

        it { expect(Course.count).to eq(1) }
        it { expect(last_response.status).to eq(200) }
        it { expect(json["uuid"]).to eq(Course.last.uuid) }
      end

      context "trying to create an invalid course" do
        before :each do
          course.start_date = nil
          do_action
        end

        it { expect(last_response.status).to eq(400) }
        it { expect(json['errors']).to have_key('start_date') }
      end

      context "creating an course" do
        before do
          course.start_date = Date.new(2014, 01, 05)
          course.end_date = Date.new(2014, 01, 11)
          do_action
        end

        subject { last_course }

        it { expect(last_response.status).to eq(200) }
        it { expect(subject.name).to eq(course.name) }
        it { expect(subject.teacher).to eq(teacher) }
        #it { expect(subject.organization).to eq(organization) }
        it { expect(subject.start_date).to eq(course.start_date) }
        it { expect(subject.end_date).to eq(course.end_date) }
      end
    end
  end

  describe "PATCH /api/v1/teacher/courses/:uuid.json" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      def do_action
        patch "/api/v1/teacher/courses/#{course.uuid}.json", parameters.merge(auth_params(teacher)).to_json
      end

      skip "invalid course"
      skip "another teacher's course"

      before do
        course.save!
        course.name = "NEW NAME"
        do_action
      end

      it { expect(last_course.name).to eq course.name }

      it { expect(last_response.status).to eq(200) }
      it { expect(json["uuid"]).to eq(Course.last.uuid) }
    end
  end

  describe "DELETE /api/v1/teacher/courses/:uuid.json" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      before { course.save! }

      skip "another teacher's course"

      def do_action
        delete "/api/v1/teacher/courses/#{course.uuid}.json", auth_params(teacher).to_json
      end

      it "should destroy the course" do
        expect do
          do_action
        end.to change(Course, :count).by(-1)
      end
    end
  end
end
