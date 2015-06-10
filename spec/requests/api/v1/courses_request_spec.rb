require 'spec_helper'

describe Api::V1::CoursesController do

  let(:teacher) { create(:profile) }
  let(:student) { create(:profile) }
  let(:course) { create(:course, teacher: teacher, students: [student]) }
  let(:event) { create(:event, course: course) }

  def last_course
    Course.order('created_at desc').first
  end

  describe "GET /api/v1/courses.json" do
    let!(:another_course) { create(:course) }

    def do_action
      get "/api/v1/courses.json", auth_params(teacher)
    end

    before(:each) do
      course.save!
      do_action
    end

    it { expect(last_response.status).to eq(200) }

    describe "collection" do
      subject { json }

      it do
        expect(subject).to eq([{
          "uuid" => course.uuid,
          "name" => course.name,
          "start_date" => course.start_date.to_s,
          "end_date" => course.end_date.to_s,
          "grade" => course.grade,
          "class_name" => course.class_name,
          "order" => course.order,
          "access_code" => course.access_code,
          "institution" => course.institution,
          "abbreviation" => course.abbreviation,
          "color" => SHARED_CONFIG["v1"]["courses"]["schemes"][course.order],
          "weekly_schedules" => [],
          "students_count" => 1,
          "user_role" => "teacher",
          "teacher" => { "name" => teacher.name }
        }])
      end
    end
  end

  describe "GET /api/v1/courses/:identifier.json" do
    let!(:event) { create(:event, course: course) }
    let!(:event_from_past_month) { create(:event, course: course, start_at: 1.month.ago) }
    let!(:event_from_next_month) { create(:event, course: course, start_at: 1.month.from_now) }
    let!(:event_from_another_teacher) { create(:event, course: create(:course, teacher: create(:profile))) }
    let!(:event_from_another_course) { create(:event, course: create(:course, teacher: teacher)) }

    shared_examples_for "get course" do |role|

      def do_action(parameters = {})
        get "/api/v1/courses/#{identifier}.json", auth_params(profile).merge(parameters)
      end

      context "in current month" do
        context "fetching by #uuid" do
          before { do_action }
          let(:identifier) { course.uuid }

          subject { json["course"] }

          it { expect(last_response.status).to eq(200) }
          it do
            expect(subject).to eq({
              "uuid" => course.uuid,
              "name" => course.name,
              "start_date" => course.start_date.to_s,
              "end_date" => course.end_date.to_s,
              "grade" => course.grade,
              "class_name" => course.class_name,
              "order" => course.order,
              "access_code" => course.access_code,
              "institution" => course.institution,
              "abbreviation" => course.abbreviation,
              "color" => SHARED_CONFIG["v1"]["courses"]["schemes"][course.order],
              "weekly_schedules" => [],
              "students_count" => 1,
              "teacher" => {"name" => teacher.name},
              "user_role" => role,
              "events" => [{
                "id" => event.id,
                "uuid" => event.uuid,
                "order" => event.order,
                "status" => event.status,
                "formatted_status" => event.formatted_status,
                "start_at" => event.start_at.utc.iso8601,
                "end_at" => event.end_at.utc.iso8601,
                "formatted_classroom" => "101"
              }],
              "previous_month" => 1.month.ago.beginning_of_month.utc.iso8601,
              "current_month" => Time.current.beginning_of_month.utc.iso8601,
              "next_month" => 1.month.from_now.beginning_of_month.utc.iso8601
            })
          end
        end

        context "fetching by #access_code" do
          before { do_action }
          let(:identifier) { course.access_code }

          subject { json["course"] }

          it { expect(last_response.status).to eq(200) }
          it { expect(subject["access_code"]).to eq(course.access_code) }
        end

        context "course not found" do
          let(:identifier) { 'not-found' }

          it { expect { do_action }.to raise_error(ActiveRecord::RecordNotFound) }
        end

        context "course not registered" do
          let!(:course) { create(:course, teacher: create(:profile)) }
          let(:identifier) { course.uuid }

          it do
            expect { do_action }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end

      context "in previous month" do
        let(:identifier) { course.uuid }

        before do
          do_action(month: 1.month.ago.beginning_of_month.utc.iso8601)
        end
        subject { json["course"] }

        it { expect(subject["previous_month"]).to eq(2.month.ago.beginning_of_month.utc.iso8601) }
        it { expect(subject["current_month"]).to eq(1.months.ago.beginning_of_month.utc.iso8601) }
        it { expect(subject["next_month"]).to eq(Time.current.beginning_of_month.utc.iso8601) }

        describe "events" do
          subject { json["course"]["events"].map { |e| e["uuid"] } }

          it { expect(subject).to eq([event_from_past_month.uuid]) }
        end
      end

      context "in next month" do
        let(:identifier) { course.uuid }

        before do
          do_action(month: 1.month.from_now.beginning_of_month.utc.iso8601)
        end
        subject { json["course"] }

        it { expect(subject["previous_month"]).to eq(Time.current.beginning_of_month.utc.iso8601) }
        it { expect(subject["current_month"]).to eq(1.months.from_now.beginning_of_month.utc.iso8601) }
        it { expect(subject["next_month"]).to eq(2.months.from_now.beginning_of_month.utc.iso8601) }

        describe "events" do
          subject { json["course"]["events"].map { |e| e["uuid"] } }

          it { expect(subject).to eq([event_from_next_month.uuid]) }
        end
      end
    end

    context "as teacher" do
      let(:profile) { teacher }
      it_behaves_like "get course", 'teacher'
    end

    context "as student" do
      let(:profile) { student }
      it_behaves_like "get course", 'student'
    end
  end

  describe "POST /api/v1/courses/:uuid/register" do
    let(:new_course) { create :course }

    it { expect(student.courses).not_to include(new_course) }
    it { expect(new_course.students).to eq([]) }

    context "valid content type" do

      def do_action
        allow(TrackerWrapper).to receive_message_chain(:new, :track)
        post "/api/v1/courses/#{identifier}/register.json", auth_params(student).to_json
      end

      context "existing course" do
        before { do_action }

        let(:identifier) { new_course.uuid }

        it { expect(last_response.status).to eq(200) }
        it { expect(new_course.students).to eq([student]) }
        it { expect(student.courses).to include(new_course) }
      end

      context "identifying by access code" do
        before { do_action }

        let(:identifier) { new_course.access_code }

        it { expect(last_response.status).to eq(200) }
        it { expect(new_course.students).to eq([student]) }
        it { expect(student.courses).to include(new_course) }
      end

      context "course not found" do
        let(:identifier) { 'not-found' }

        it { expect { do_action }.to raise_error(ActiveRecord::RecordNotFound) }
      end

      context "already registered to course" do
        let(:identifier) { new_course.uuid }

        before { 2.times { do_action } }

        it { expect(last_response.status).to eq(400) }
        it { expect(new_course.students.reload).to eq([student]) }
      end
    end
  end

  describe "DELETE /api/v1/courses/:uuid/unregister" do
    def do_action
      delete "/api/v1/courses/#{identifier}/unregister.json", auth_params(student).to_json
    end

    context "existing course" do
      before { do_action }

      let(:identifier) { course.uuid }

      it { expect(last_response.status).to eq(200) }
      it { expect(course.students.reload).to eq([]) }
      it { expect(student.courses.reload).not_to include(course) }
    end

    context "identifying by access code" do
      before { do_action }

      let(:identifier) { course.access_code }

      it { expect(last_response.status).to eq(200) }
      it { expect(course.students.reload).to eq([]) }
      it { expect(student.courses.reload).not_to include(course) }
    end

    context "course not found" do
      let(:identifier) { 'not-found' }

      it { expect { do_action }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  describe "GET /api/v1/courses/:uuid/students.json" do
    before do
      course.save!
      do_action
    end

    def do_action
      get "/api/v1/courses/#{course.uuid}/students.json", auth_params(teacher)
    end

    describe "students" do
      let(:target) { student }
      subject { json[0] }
      it_behaves_like "request return check", %w(uuid name email)
    end
  end

  describe "POST /api/v1/courses.json" do
    skip "authorization"

    def do_action
      post "/api/v1/courses.json", course_params.merge(auth_params(teacher)).to_json
    end

    let(:course) { build(:course) }
    let(:course_params) do
      {
        name: course.name,
        start_date: course.start_date,
        end_date: course.end_date,
        class_name: course.class_name,
        grade: course.grade,
        institution: course.institution
      }
    end

    it "should schedule its events" do
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
      it { expect(subject.start_date).to eq(course.start_date) }
      it { expect(subject.end_date).to eq(course.end_date) }
    end
  end

  describe "PATCH /api/v1/courses/:uuid.json" do
    def do_action
      patch "/api/v1/courses/#{course.uuid}.json", course_params.merge(auth_params(teacher)).to_json
    end

    let(:course_params) do
      {
        name: "Some name"
      }
    end

    skip "invalid parameters"
    skip "authorization"

    before do
      do_action
    end

    it { expect(last_response.status).to eq(200) }
    it { expect(course.reload.name).to eq "Some name" }
    it { expect(json).to eq({ "uuid" => course.uuid }) }
  end

  describe "DELETE /api/v1/courses/:uuid.json" do
    skip "authorization"

    def do_action
      delete "/api/v1/courses/#{course.uuid}.json", auth_params(teacher).to_json
    end

    it "should destroy the course" do
      course.save!
      expect do
        do_action
      end.to change(Course, :count).by(-1)
    end
  end

  describe "GET /api/v1/courses/:access_code/search" do
    let(:unregistered_course) { create(:course, teacher: teacher) }

    def do_action
      get "/api/v1/courses/#{identifier}/search.json", auth_params(student)
    end

    context "non existent course" do
      let(:identifier) { 'not-found' }

      it { expect { do_action }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "existent course" do
      let(:identifier) { unregistered_course.access_code }

      before { do_action }

      it do
        expect(json).to eq(
          "course" => {
            "uuid" => unregistered_course.uuid,
            "access_code" => unregistered_course.access_code,
            "name" => unregistered_course.name,
            "class_name" => unregistered_course.class_name,
            "institution" => unregistered_course.institution,
            "teacher" => { "name" =>  teacher.name}
          }
        )
      end
    end
  end
end
