require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Comments" do
  parameter :user_email, "User's email", required: true
  parameter :user_token, "User's authentication_token", required: true
  let(:user_email) { teacher.email }
  let(:user_token) { teacher.authentication_token }

  let(:json) { JSON.parse(response_body).deep_symbolize_keys }
  let!(:teacher) { create(:profile) }
  let!(:course) { create(:course, teacher: teacher) }
  let!(:weekly_schedule) do
    create :weekly_schedule,
      course: course,
      weekday: 3,
      start_time: '14:00',
      end_time: '16:00'
  end

  post "/api/v1/comments.json" do
    before do
      Timecop.freeze Time.zone.parse('2015-10-20 00:00')
    end
    after { Timecop.return }
    let(:raw_post) { params.to_json }
    parameter :course_id, "Course's uuid", required: true, scope: :comment
    parameter :event_start_at, 'Event starting date time', required: true, scope: :comment
    parameter :body, 'Comment Body', required: true, scope: :comment
    parameter :attachment_ids, "Comment's attachments ids", required: true, scope: :comment

    response_field :id, "Comment ID"
    response_field :profile_id, "Profile who created the comment"
    response_field :event_start_at, "Event starting date time"
    response_field :body, "Comment body"

    let(:course_id) { course.uuid }
    let(:event_start_at) { "2015-10-21T14:00:00.000-02:00" }
    let!(:event_from_another_course) { create(:event, start_at: event_start_at) }
    let(:comment) { Comment.first }
    let(:body) { 'woot!' }
    let(:attachment_ids) { [attachment.id] }
    let(:attachment) { create(:attachment) }

    def event
      course.events.reload.last
    end

    example_request 'Creating a comment', document: :public do
      expect(event.comments.count).to be 1
    end

    example 'creates non-persisted event' do
      expect { do_request }.to change { course.events.count }.by(1)
    end

    example "comment attributes" do
      file_url = 'http://www.example.com/file.txt'
      allow_any_instance_of(Attachment).to receive(:url).and_return(file_url)

      do_request
      expect(json).to eq(
        comment: {
          event_start_at: event_start_at,
          created_at: Time.current.iso8601(3),
          body: body,
          id: comment.id,
          removed_at: nil,
          user: {
            name: teacher.name,
            avatar_url: nil,
            id: teacher.id
          },
          attachments: [
            id: attachment.id,
            original_filename: attachment.original_filename,
            file_size: attachment.file_size,
            url: file_url
          ]
        }
      )
    end

    example "delivers system notifications for course members" do
      notification = double('NewCommentNotification', deliver: nil)
      allow(NewCommentNotification).to receive(:new).and_return(notification)
      do_request
      expect(NewCommentNotification)
        .to have_received(:new).with(an_instance_of(Comment), teacher)
    end

    context "with an empty body" do
      let(:body) { nil }
      example_request "sending an empty body" do
        expect(json).to eq(
          errors: {
            body: [I18n.t('errors.messages.blank')]
          }
        )
      end
    end
  end

  delete "/api/v1/comments/:id.json" do
    let(:id) { comment.id }

    let(:raw_post) { params.to_json }

    before { Timecop.freeze }
    after { Timecop.return }

    context "deleting own comment" do
      let!(:comment) { create(:comment, profile: teacher) }

      example_request "removes a comment" do
        expect(comment.reload).to be_removed
      end

      example_request "returns the updated comment" do
        expect(json).to eq(
          comment: {
            event_start_at: comment.event.start_at.iso8601(3),
            created_at: Time.current.iso8601(3),
            id: comment.id,
            removed_at: Time.current.iso8601(3),
            user: {
              name: comment.profile.name,
              avatar_url: nil,
              id: comment.profile.id
            }
          }
        )
      end
    end

    context "trying to remove other person's comment" do
      let!(:comment) { create(:comment) }

      example "removes a comment" do
        expect { do_request }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
