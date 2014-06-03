require 'spec_helper'

describe Api::V1::Teacher::EventsController do

  let!(:teacher) { create :teacher }
  let(:organization) { create :organization }
  let(:course) { build :course, teacher: teacher, organization: organization }

  let(:parameters) do
    params = {course: {}}
    %w(name start_date end_date start_time end_time classroom weekdays organization_id).each do |attr|
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
          subject { json }
          it { expect(subject["uuid"]).to eq course.uuid }

          pending "course's attributes"

          describe "course's events" do
            subject { json["events"].map {|e| e["uuid"]} }
            it { expect(subject).to include event.uuid }
            it { expect(subject).not_to include event_from_another_teacher.uuid }
            it { expect(subject).not_to include event_from_another_course.uuid }
          end
        end
      end

      context "another teacher's course" do
        let!(:course) { create(:course, teacher: create(:teacher)) }
        it { expect(response.status).to eq 404 }
      end
    end
  end

  describe "POST /api/v1/teacher/courses.json" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      def do_action
        post "/api/v1/teacher/courses.json", parameters.merge(auth_params(teacher))
      end

      pending "invalid course"

      it "should create the course" do
        expect do
          do_action
        end.to change{ Course.count }.from(0).to(1)
      end

      context "creating an course" do
        before do
          course.start_date = Date.new(2014, 01, 05)
          course.end_date = Date.new(2014, 01, 11)
          course.weekdays = [2, 4]
          course.start_time = "14:00"
          course.end_time = "16:00"
          course.classroom = "201"
          course.save!
          do_action
        end

        subject { assigns[:course] }

        it { expect(subject.name).to eq(course.name) }
        it { expect(subject.teacher).to eq(teacher) }
        it { expect(subject.organization).to eq(organization) }
        it { expect(subject.classroom).to eq(course.classroom) }
        it { expect(subject.start_date).to eq(course.start_date) }
        it { expect(subject.end_date).to eq(course.end_date) }
        it { expect(subject.start_time).to eq(course.start_time) }
        it { expect(subject.end_time).to eq(course.end_time) }
        it { expect(subject.weekdays).to eq(course.weekdays) }

        describe "#events" do
          subject { assigns[:course].events }

          its(:count) { should eq(2) }
          it { expect(subject[0].start_at.to_i).to eq(Time.new(2014, 01, 7, 14, 00).to_i)}
          it { expect(subject[1].start_at.to_i).to eq(Time.new(2014, 01, 9, 14, 00).to_i)}
          it { expect(subject[0].duration).to eq("02:00:00")}
          it { expect(subject[1].duration).to eq("02:00:00")}
        end
      end
    end
  end

  describe "PATCH /api/v1/teacher/courses/:uuid.json" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      def do_action
        patch "/api/v1/teacher/courses/#{course.uuid}.json", parameters.merge(auth_params(teacher))
      end

      pending "invalid course"
      pending "another teacher's course"

      before do
        course.save!
        course.name = "NEW NAME"
        do_action
      end

      it { expect(assigns[:course].name).to eq course.name }
    end
  end

  describe "DELETE /api/v1/teacher/courses/:uuid.json" do

    it_behaves_like "API authentication required"

    context "authenticated" do

      before { course.save! }

      pending "another teacher's course"

      def do_action
        delete "/api/v1/teacher/courses/#{course.uuid}.json", auth_params(teacher)
      end

      it "should destroy the course" do
        expect do
          do_action
        end.to change(Course, :count).by(-1)
      end
    end
  end
end
