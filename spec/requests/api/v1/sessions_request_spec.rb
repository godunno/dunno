require 'spec_helper'

describe Api::V1::SessionsController do
  let(:password) { '12345678' }
  let!(:student) { create(:student, password: password) }
  let!(:teacher) { create(:teacher, password: password) }
  let!(:course) { create(:course, students: [student], teacher: teacher) }
  let!(:event) { create(:event, course: course) }
  let!(:message_one) do
    message = create(:timeline_message, content: "First message")
    create(:timeline_interaction, timeline: event.timeline, interaction: message)
    message.vote_by(create(:student))
    message
  end
  let!(:message_two) do
    message = create(:timeline_message, content: "Second message")
    create(:timeline_interaction, timeline: event.timeline, interaction: message)
    message
  end
  let(:course_pusher_events) { CoursePusherEvents.new(student) }

  describe "student" do
    describe "POST /api/v1/students/sign_in" do

      context "correct authentication" do

        before(:each) do
          post "/api/v1/students/sign_in", { student: { email: student.email, password: password } }
        end

        it { expect(response).to be_successful }
        it { expect(controller.current_student).to eq(student) }

        it { expect(json["courses"][0]["uuid"]).to eq(course.uuid) }
        it { expect(json["courses"][0]["channel"]).to eq(course.channel) }
        it { expect(json["courses"][0]["teacher"]["name"]).to eq(course.teacher.name) }
        it { expect(json["name"]).to eq(student.name) }
        it { expect(json["email"]).to eq(student.email) }
        it { expect(json["avatar"]).to eq(student.avatar) }
        it { expect(json["authentication_token"]).to eq(student.authentication_token) }

        describe "course pusher events" do
          let(:target) { course_pusher_events }
          subject { json }
          it_behaves_like "request return check", %w(open_event)
        end

        describe "timeline data" do
          let(:messages) { json["courses"][0]["events"][0]["timeline"]["messages"] }
          let(:response_message_one) { messages.find { |msg| msg["id"] == message_one.id } }
          let(:response_message_two) { messages.find { |msg| msg["id"] == message_two.id } }

          it { expect(messages.count).to eq(2) }
          it { expect(response_message_one["content"]).to eq(message_one.content) }
          it { expect(response_message_two["content"]).to eq(message_two.content) }

          it { expect(response_message_one["up_votes"]).to eq(1) }
          it { expect(response_message_one["down_votes"]).to eq(0) }

          it { expect(response_message_two["up_votes"]).to eq(0) }
          it { expect(response_message_two["down_votes"]).to eq(0) }
        end

        it "should allow access with authentication_token after the sign in" do
          get "/api/v1/events.json",
            { student_email: student.email, student_token: student.authentication_token }
          expect(controller.current_student).to eq(student)
        end
      end

      context "incorrect authentication" do

        def do_action
          post "/api/v1/students/sign_in.json", student_hash
        end

        context "incorrect password" do
          let(:student_hash) { { student: { email: student.email, password: 'abcdefgh' } } }
          it_behaves_like "incorrect sign in"
        end

        context "incorrect email" do
          let(:student_hash) { { student: { email: "incorrect.email@gmail.com", password: password } } }
          it_behaves_like "incorrect sign in"
        end
      end
    end
  end

  describe "teacher" do
    describe "POST /api/v1/teachers/sign_in" do

      context "correct authentication" do

        before(:each) do
          post "/api/v1/teachers/sign_in", { teacher: { email: teacher.email, password: password } }
        end

        it { expect(response).to be_successful }
        it { expect(controller.current_teacher).to eq(teacher) }

        it { expect(json["courses"][0]["uuid"]).to eq(course.uuid) }
        it { expect(json["courses"][0]["channel"]).to eq(course.channel) }
        it { expect(json["courses"][0]["events"][0]["uuid"]).to eq(event.uuid) }
        it { expect(json["name"]).to eq(teacher.name) }
        it { expect(json["email"]).to eq(teacher.email) }
        it { expect(json["avatar"]).to eq(teacher.avatar) }
        it { expect(json["authentication_token"]).to eq(teacher.authentication_token) }

        it "should allow access with authentication_token after the sign in" do
          pending "Implement some endpoint to test this feature"
          get "/api/v1/events.json",
            { teacher_email: teacher.email, teacher_token: teacher.authentication_token }
          expect(controller.current_teacher).to eq(teacher)
        end
      end

      context "incorrect authentication" do

        def do_action
          post "/api/v1/teachers/sign_in.json", teacher_hash
        end

        context "incorrect password" do
          let(:teacher_hash) { { teacher: { email: teacher.email, password: 'abcdefgh' } } }
          it_behaves_like "incorrect sign in"
        end

        context "incorrect email" do
          let(:teacher_hash) { { teacher: { email: "incorrect.email@gmail.com", password: password } } }
          it_behaves_like "incorrect sign in"
        end
      end
    end
  end
end
