require 'spec_helper'

describe Api::V1::Teacher::NotificationsController do
  let(:teacher) { create :teacher }

  describe "POST /api/v1/teacher/notifications.json" do
    it_behaves_like "API authentication required"
    context "authenticated" do
      let(:message) { "MESSAGE" }
      let(:new_abbreviation) { "New Abbr" }
      let(:course) { create :course, teacher: teacher }

      let(:params_hash) do
        {
          notification: {
            "message" => message,
            "course_id" => course.uuid,
            "abbreviation" => new_abbreviation
          }
        }
      end

      def do_action
        post "/api/v1/teacher/notifications.json", auth_params(teacher).merge(params_hash).to_json
      end

      context "trying to notificate another teacher's course" do
        let(:course) { create :course, teacher: create(:teacher) }

        it { expect { do_action }.to raise_error(ActiveRecord::RecordNotFound) }
      end

      context "creating an invalid notification" do
        let(:message) { '' }
        before { do_action }
        it { expect(last_response.status).to eq(422) }
        it do
          expect(json).to eq(
            "errors" => {
              "message" => [
                { "error" => "blank" },
                { "error" => "too_short", "count"=>1 }
              ]
            }
          )
        end
      end

      context "updating course with invalid abbreviation" do
        let(:new_abbreviation) { 'too long abbreviation' }
        before { do_action }
        it { expect(last_response.status).to eq(422) }
        it do
          expect(json).to eq(
            "errors" => {
              "abbreviation" => [
                { "error" => "too_long", "count" => 10 }
              ]
            }
          )
        end
      end

      context "notificating a course" do
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
        it { expect(subject.course.abbreviation).to eq(new_abbreviation) }
      end
    end
  end
end
