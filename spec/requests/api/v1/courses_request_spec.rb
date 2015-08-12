require 'spec_helper'

describe Api::V1::CoursesController do
  let!(:teacher) { create(:profile, user: create(:user, name: "Teacher")) }
  let!(:student) { create(:profile, user: create(:user, name: "Student")) }
  let!(:course) { create(:course, start_date: 1.month.ago, end_date: 1.month.from_now, teacher: teacher, students: [student]) }
  let!(:weekly_schedule) { create(:weekly_schedule, course: course) }
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
          "active" => true,
          "start_date" => course.start_date.to_s,
          "end_date" => course.end_date.to_s,
          "abbreviation" => course.abbreviation,
          "grade" => course.grade,
          "class_name" => course.class_name,
          "order" => course.order,
          "access_code" => course.access_code,
          "institution" => course.institution,
          "color" => SHARED_CONFIG["v1"]["courses"]["schemes"][course.order],
          "user_role" => "teacher",
          "students_count" => course.students.count,
          "teacher" => { "name" => teacher.name },
          "weekly_schedules"=> [
            "uuid" => weekly_schedule.uuid,
            "weekday" => weekly_schedule.weekday,
            "start_time" => weekly_schedule.start_time,
            "end_time" => weekly_schedule.end_time,
            "classroom" => weekly_schedule.classroom
          ],
          "members_count" => 2,
          "members" => [
            { "name" => "Teacher", "role" => "teacher" },
            { "name" => "Student", "role" => "student" }
          ]
        }])
      end
    end
  end

  describe "GET /api/v1/courses/:identifier.json" do
    let(:course) { create(:course, start_date: 2.months.ago, end_date: 2.months.from_now, teacher: teacher, students: [student]) }
    let!(:event_from_another_teacher) { create(:event, course: create(:course, teacher: create(:profile))) }
    let!(:event_from_another_course) { create(:event, course: create(:course, teacher: teacher)) }

    shared_examples_for "get course" do |role|
      let(:first_date)  { Time.zone.parse('2015-08-03 09:00') }
      let(:second_date) { Time.zone.parse('2015-08-10 09:00') }
      let(:third_date)  { Time.zone.parse('2015-08-17 09:00') }
      let(:fourth_date) { Time.zone.parse('2015-08-24 09:00') }
      let(:fifth_date)  { Time.zone.parse('2015-08-31 09:00') }

      before do
        Timecop.freeze first_date
        course.save!
      end

      after { Timecop.return }

      let(:weekly_schedule) { create(:weekly_schedule, course: course, weekday: 1, start_time: '09:00', end_time: '11:00') }

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
            expect(subject).to eq(
              "uuid" => course.uuid,
              "active" => true,
              "name" => course.name,
              "start_date" => course.start_date.to_s,
              "end_date" => course.end_date.to_s,
              "grade" => course.grade,
              "class_name" => course.class_name,
              "order" => course.order,
              "access_code" => course.access_code,
              "institution" => course.institution,
              "abbreviation" => course.abbreviation,
              "students_count" => course.students.count,
              "color" => SHARED_CONFIG["v1"]["courses"]["schemes"][course.order],
              "teacher" => { "name" => teacher.name },
              "weekly_schedules" => [
                "uuid" => weekly_schedule.uuid,
                "weekday" => weekly_schedule.weekday,
                "start_time" => weekly_schedule.start_time,
                "end_time" => weekly_schedule.end_time,
                "classroom" => weekly_schedule.classroom
              ],
              "members_count" => 2,
              "members" => [
                { "name" => "Teacher", "role" => "teacher" },
                { "name" => "Student", "role" => "student" }
              ],
              "user_role" => role,
              "events" => [
                {
                  "order" => 8,
                  "formatted_status" => 'empty',
                  "start_at" => first_date.utc.iso8601,
                  "end_at" => (first_date + 2.hours).utc.iso8601,
                  "classroom" => nil
                },
                {
                  "order" => 9,
                  "formatted_status" => 'empty',
                  "start_at" => second_date.utc.iso8601,
                  "end_at" => (second_date + 2.hours).utc.iso8601,
                  "classroom" => nil
                },
                {
                  "order" => 10,
                  "formatted_status" => 'empty',
                  "start_at" => third_date.utc.iso8601,
                  "end_at" => (third_date + 2.hours).utc.iso8601,
                  "classroom" => nil
                },
                {
                  "order" => 11,
                  "formatted_status" => 'empty',
                  "start_at" => fourth_date.utc.iso8601,
                  "end_at" => (fourth_date + 2.hours).utc.iso8601,
                  "classroom" => nil
                },
                {
                  "order" => 12,
                  "formatted_status" => 'empty',
                  "start_at" => fifth_date.utc.iso8601,
                  "end_at" => (fifth_date + 2.hours).utc.iso8601,
                  "classroom" => nil
                },
              ],
              "previous_month" => 1.month.ago.beginning_of_month.utc.iso8601,
              "current_month" => Time.current.beginning_of_month.utc.iso8601,
              "next_month" => 1.month.from_now.beginning_of_month.utc.iso8601
            )
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
          subject { json["course"]["events"].map { |e| e["start_at"] } }

          it do
            expect(subject).to eq([
              "2015-07-06T12:00:00Z",
              "2015-07-13T12:00:00Z",
              "2015-07-20T12:00:00Z",
              "2015-07-27T12:00:00Z"
            ])
          end
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
          subject { json["course"]["events"].map { |e| e["start_at"] } }

          it do
            expect(subject).to eq([
              "2015-09-07T12:00:00Z",
              "2015-09-14T12:00:00Z",
              "2015-09-21T12:00:00Z",
              "2015-09-28T12:00:00Z"
            ])
          end
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
    let(:new_course) { create :course, teacher: teacher }

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

        before { do_action }

        def do_action
          post "/api/v1/courses/#{identifier}/register.json", auth_params(teacher).to_json
        end

        it do
          expect(json).to eq(
            "errors" => { "unprocessable" => "Você já faz parte desta disciplina." }
          )
        end

        it { expect(last_response.status).to eq 422 }
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

    before { Course.destroy_all }

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
    let!(:weekly_schedule) { create(:weekly_schedule, course: course, weekday: 1, start_time: '09:00', end_time: '11:00', classroom: 'A-1') }

    def do_action
      patch "/api/v1/courses/#{course.uuid}.json", course_params.merge(auth_params(teacher)).to_json
    end

    let(:course_params) do
      {
        course: course.attributes.merge(
          name: "Some name",
          weekly_schedules: [
            uuid: weekly_schedule.uuid,
            weekday: 2,
            start_time: '14:00',
            end_time: '16:00',
            classroom: 'B-2'
          ]
        )
      }
    end

    skip "invalid parameters"
    skip "authorization"

    before do
      do_action
    end

    it { expect(last_response.status).to eq(200) }
    it { expect(course.reload.name).to eq "Some name" }
    it { expect(json).to eq("uuid" => course.uuid) }

    describe "weekly schedule" do
      subject { weekly_schedule.reload }

      it { expect(subject.weekday).to eq 2 }
      it { expect(subject.start_time).to eq '14:00' }
      it { expect(subject.end_time).to eq '16:00' }
      it { expect(subject.classroom).to eq 'B-2' }
    end
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
            "teacher" => { "name" =>  teacher.name }
          }
        )
      end

      context "with user already part of course" do
        def do_action
          get "/api/v1/courses/#{identifier}/search.json", auth_params(teacher)
        end

        it do
          expect(json).to eq(
            "errors" => { "unprocessable" => "Você já faz parte desta disciplina." }
          )
        end

        it { expect(last_response.status).to eq 422 }
      end
    end
  end
end
