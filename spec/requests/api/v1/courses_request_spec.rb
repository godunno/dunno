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
    let!(:blocked_course) { create(:course, students: [student]) }

    def do_action
      get "/api/v1/courses.json", auth_params(student)
    end

    before(:each) do
      course.save!
      student.block_in!(blocked_course)
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
          "premium" => course.premium,
          "start_date" => course.start_date.to_s,
          "end_date" => course.end_date.to_s,
          "abbreviation" => course.abbreviation,
          "grade" => course.grade,
          "class_name" => course.class_name,
          "order" => course.order,
          "access_code" => course.access_code,
          "institution" => course.institution,
          "color" => SHARED_CONFIG["v1"]["courses"]["schemes"][course.order],
          "user_role" => "student",
          "students_count" => course.students.count,
          "teacher" => { "name" => teacher.name, "avatar_url" => nil },
          "weekly_schedules" => [
            "uuid" => weekly_schedule.uuid,
            "weekday" => weekly_schedule.weekday,
            "start_time" => weekly_schedule.start_time,
            "end_time" => weekly_schedule.end_time,
            "classroom" => weekly_schedule.classroom
          ],
          "members_count" => 2,
          "members" => [
            {
              "id" => teacher.id,
              "name" => "Teacher",
              "role" => "teacher",
              "avatar_url" => nil
            },
            {
              "id" => student.id,
              "name" => "Student",
              "role" => "student",
              "avatar_url" => nil
            }
          ]
        }])
      end
    end
  end

  describe "GET /api/v1/courses/:identifier.json" do
    let(:course) { create(:course, teacher: teacher, students: [student]) }

    shared_examples_for "get course" do |role|
      let!(:weekly_schedule) { create(:weekly_schedule, course: course) }
      let!(:media_from_published_event) do
        create :media,
               topics: [
                 create(:topic, event: create(:event, :published, course: course))
               ]
      end
      let!(:media_from_unpublished_event) do
        create :media,
               topics: [
                 create(:topic, event: create(:event, :draft, course: course))
               ]
      end

      let(:tracker_double) { double("TrackEvent::CourseAccessed", track: nil) }

      before do
        course.save!
        course.reload
        allow(TrackEvent::CourseAccessed)
          .to receive(:new)
          .with(course, profile)
          .and_return(tracker_double)
      end

      def do_action(parameters = {})
        get "/api/v1/courses/#{identifier}.json", auth_params(profile).merge(parameters)
      end

      context "in current month" do
        context "fetching by #uuid" do
          before { do_action }
          let(:identifier) { course.uuid }

          subject { json["course"] }

          it { expect(last_response.status).to eq(200) }
          it { expect(tracker_double).to have_received(:track) }
          it do
            expect(subject).to eq(
              "uuid" => course.uuid,
              "active" => true,
              "premium" => course.premium,
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
              "teacher" => { "name" => teacher.name, "avatar_url" => nil },
              "medias_count" => 1,
              "weekly_schedules" => [
                "uuid" => weekly_schedule.uuid,
                "weekday" => weekly_schedule.weekday,
                "start_time" => weekly_schedule.start_time,
                "end_time" => weekly_schedule.end_time,
                "classroom" => weekly_schedule.classroom
              ],
              "members_count" => 2,
              "members" => [
                {
                  "id" => teacher.id,
                  "name" => "Teacher",
                  "role" => "teacher",
                  "avatar_url" => nil
                },
                {
                  "id" => student.id,
                  "name" => "Student",
                  "role" => "student",
                  "avatar_url" => nil
                }
              ],
              "user_role" => role
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
    end

    context "as teacher" do
      let(:profile) { teacher }
      it_behaves_like "get course", 'teacher'
    end

    context "as student" do
      let(:profile) { student }
      it_behaves_like "get course", 'student'

      context "when blocked" do
        before do
          student.block_in!(course)
          do_action
        end

        def do_action
          get "/api/v1/courses/#{course.uuid}.json", auth_params(profile)
        end

        it { expect(last_response.status).to be 403 }
      end
    end
  end

  describe "POST /api/v1/courses/:uuid/register" do
    let(:new_course) { create :course, teacher: teacher }
    let(:notification_double) { double("NewMemberNotification", deliver: nil) }

    it { expect(student.courses).not_to include(new_course) }
    it { expect(new_course.students).to eq([]) }

    context "valid content type" do
      def do_action
        allow(TrackerWrapper)
          .to receive_message_chain(:new, :track)
        allow(NewMemberNotification)
          .to receive(:new)
          .with(new_course, student)
          .and_return(notification_double)
        post "/api/v1/courses/#{identifier}/register.json", auth_params(student).to_json
      end

      context "existing course" do
        before { do_action }

        let(:identifier) { new_course.uuid }

        it { expect(last_response.status).to eq(200) }
        it { expect(new_course.students).to eq([student]) }
        it { expect(student.courses).to include(new_course) }
        it { expect(notification_double).to have_received(:deliver) }
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

    context "as a teacher" do
      def do_action
        delete "/api/v1/courses/#{course.uuid}/unregister.json", auth_params(teacher).to_json
      end

      it "should not allow to unregister" do
        do_action
        expect(last_response.status).to be 403
      end
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

    before do
      Course.destroy_all
      allow(CourseEventsIndexerWorker).to receive(:perform_async)
    end

    context "creating the course" do
      before do
        course.start_date = Date.new(2014, 01, 05)
        course.end_date = Date.new(2014, 01, 11)
        do_action
      end

      subject { json["course"] }

      it { expect(Course.count).to eq(1) }
      it { expect(last_response.status).to eq(200) }

      it { expect(CourseEventsIndexerWorker).not_to have_received(:perform_async) }

      it { expect(subject["uuid"]).to eq(last_course.uuid) }
      it { expect(subject["name"]).to eq(course.name) }
      it { expect(subject["teacher"]["name"]).to eq(teacher.name) }
      it { expect(subject["start_date"]).to eq(course.start_date.to_s) }
      it { expect(subject["end_date"]).to eq(course.end_date.to_s) }
    end

    context "trying to create an invalid course" do
      before :each do
        course.name = nil
        do_action
      end

      it { expect(last_response.status).to eq(422) }
      it { expect(json['errors']).to have_key('name') }
    end
  end

  describe "PATCH /api/v1/courses/:uuid.json" do
    let!(:weekly_schedule) { create(:weekly_schedule, course: course, weekday: 1, start_time: '09:00', end_time: '11:00', classroom: 'A-1') }

    def do_action
      patch "/api/v1/courses/#{course.uuid}.json", course_params.merge(auth_params(teacher)).to_json
    end

    before do
      allow(CourseEventsIndexerWorker).to receive(:perform_async)
    end

    context "successfully updating course" do
      let(:course_params) do
        {
          course: course.attributes.merge(
            name: "Some name"
          )
        }
      end

      subject { json["course"] }

      skip "invalid parameters"

      before do
        do_action
      end

      it { expect(last_response.status).to eq(200) }
      it { expect(course.reload.name).to eq "Some name" }
      it { expect(subject["uuid"]).to eq(course.uuid) }
      it { expect(subject["teacher"]["name"]).to eq(teacher.name) }
      it { expect(subject["start_date"]).to eq(course.start_date.to_s) }
      it { expect(subject["end_date"]).to eq(course.end_date.to_s) }
    end

    context "updating Course#start_date to a previous date" do
      let(:start_date) { course.start_date - 1.month }

      let(:course_params) do
        {
          course: course.attributes.merge(
            start_date: start_date
          )
        }
      end

      let(:persist_spy) { double("PersistPastEvents", persist!: nil) }

      before do
        allow(PersistPastEvents)
          .to receive(:new)
          .with(course, since: start_date)
          .and_return(persist_spy)

        do_action
      end

      it { expect(persist_spy).to have_received(:persist!) }
    end

    describe "reindexing events when changing the course's period" do
      before do
        do_action
      end

      context "changing the start_date" do
        let(:course_params) do
          {
            course: course.attributes.merge(
              start_date: course.start_date + 1.day
            )
          }
        end

        it { expect(CourseEventsIndexerWorker).to have_received(:perform_async).with(course.id) }
      end

      context "changing the end_date" do
        let(:course_params) do
          {
            course: course.attributes.merge(
              end_date: course.start_date + 1.day
            )
          }
        end

        it { expect(CourseEventsIndexerWorker).to have_received(:perform_async).with(course.id) }
      end

      context "not changing the start_date nor the end_date" do
        let(:course_params) do
          {
            course: course.attributes.merge(
              name: 'Some other name'
            )
          }
        end

        it { expect(CourseEventsIndexerWorker).not_to have_received(:perform_async) }
      end
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
            "name" => unregistered_course.name,
            "start_date" => unregistered_course.start_date.to_s,
            "end_date" => unregistered_course.end_date.to_s,
            "abbreviation" => unregistered_course.abbreviation,
            "grade" => nil,
            "class_name" => unregistered_course.class_name,
            "order" => 2,
            "access_code" => unregistered_course.access_code,
            "institution" => "PUC-Rio",
            "color" => "#b6a6f3",
            "user_role" => false,
            "students_count" => 0,
            "teacher" => { "name" => "Teacher", "avatar_url" => nil },
            "active" => true,
            "premium" => unregistered_course.premium,
            "weekly_schedules" => [],
            "members_count" => 1,
            "members" => [{
              "id" => teacher.id,
              "name" => "Teacher",
              "role" => "teacher",
              "avatar_url" => nil
            }]
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

      context "blocked from course" do
        def do_action
          get "/api/v1/courses/#{course.access_code}/search.json", auth_params(student)
        end

        before do
          student.block_in!(course)
          do_action
        end

        it do
          expect(json).to eq(
            "errors" => { "unprocessable" => "Você foi bloqueado dessa disciplina" }
          )
        end

        it { expect(last_response.status).to eq 422 }
      end
    end
  end
end
