require 'spec_helper'

describe Api::V1::CoursesController do

  let(:student) { create(:student) }
  let(:course) { create(:course, students: [student]) }
  let(:teacher) { course.teacher }
  let!(:event) do
    create(:event, course: course)
  end
  let(:event_pusher_events) { EventPusherEvents.new(student.user) }

  describe "GET /api/v1/courses.json" do

    context "authenticated" do
      let!(:another_course) { create(:course) }

      before(:each) do
        get "/api/v1/courses.json", auth_params(student)
      end

      it { expect(last_response.status).to eq(200) }

      describe "collection" do

        subject { json.map { |course| course["uuid"] } }

        it { expect(subject).to include course.uuid }
        it { expect(subject).not_to include another_course.uuid }
      end

      describe "course" do

        let(:target) { course }
        let(:course_json) { json[0] }
        subject { course_json }
        it_behaves_like "request return check", %w(name uuid start_date end_date institution)

        it { expect(last_response.status).to eq(200) }

        describe "teacher" do
          let(:target) { teacher }
          subject { course_json["teacher"] }
          it_behaves_like "request return check", %w(name)
        end
      end
    end
  end

  describe "GET /api/v1/courses/:identifier.json" do

    context "authenticated" do

      def do_action
        get "/api/v1/courses/#{identifier}.json", auth_params(student)
      end

      before { course.save! }

      context "searching with uuid" do
        before { do_action }
        let(:identifier) { course.uuid }

        subject { json["course"] }

        it { expect(last_response.status).to eq(200) }
        it { expect(subject["uuid"]).to eq(course.uuid) }
        it { expect(subject["access_code"]).to eq(course.access_code) }
      end

      context "course not found" do
        let(:identifier) { 'not-found' }

        it { expect { do_action }.to raise_error(ActiveRecord::RecordNotFound) }
      end
    end
  end

  describe "POST /api/v1/courses/:uuid/register" do

    context "authenticated" do

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
  end

  describe "DELETE /api/v1/courses/:uuid/unregister" do

    context "authenticated" do

      context "valid content type" do

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
    end
  end
end
