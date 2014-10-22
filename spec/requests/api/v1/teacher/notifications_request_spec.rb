require 'spec_helper'

describe Api::V1::Teacher::NotificationsController do
  let(:teacher) { create :teacher }

  describe "POST /api/v1/teacher/notifications.json" do
    it_behaves_like "API authentication required"
    context "authenticated" do
      let(:message) { "MESSAGE" }

      let(:params_hash) do
        {
          notification: {
            "message" => message,
            "course_id" => course.uuid
          }
        }
      end

      def do_action
        post "/api/v1/teacher/notifications.json", auth_params(teacher).merge(params_hash).to_json
      end

      context "trying to notificate another teacher's course" do
        let(:course) { create :course, teacher: create(:teacher) }

        before do
          do_action
        end

        it { expect(last_response.status).to eq(400) }
      end

      context "notificating a course" do
        let(:course) { create :course, teacher: teacher }

        let(:sms_provider) { double("sms_provider", notify: nil) }
        let(:mail) { double("mail", deliver: nil) }

        before do
          allow(SmsProvider).to receive(:new).and_return(sms_provider)
          allow(NotificationMailer).to receive(:notify).and_return(mail)
          do_action
        end

        subject { Notification.last }

        it { expect(last_response.status).to eq(200) }
        it { expect(subject.message).to eq(message) }
        it { expect(subject.course).to eq(course) }
      end
    end
  end
end
