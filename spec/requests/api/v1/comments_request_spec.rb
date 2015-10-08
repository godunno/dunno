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
  let!(:event) { create(:event, course: course) }

  post "/api/v1/comments.json" do
    before { Timecop.freeze }
    after { Timecop.return }
    let(:raw_post) { params.to_json }
    parameter :event_start_at, 'Event starting date time', required: true, scope: :comment
    parameter :body, 'Comment Body', required: true, scope: :comment
    parameter :attachment_ids, "Comment's attachments ids", required: true, scope: :comment

    response_field :id, "Comment ID"
    response_field :profile_id, "Profile who created the comment"
    response_field :event_start_at, "Event starting date time"
    response_field :body, "Comment body"

    let(:event_start_at) { event.start_at }
    let(:comment) { Comment.first }
    let(:body) { 'woot!' }
    let(:attachment_ids) { [attachment.id] }
    let(:attachment) { create(:attachment) }

    example 'Creating a comment', document: :public do
      expect { do_request }.to change { event.comments.count }.by(1)
    end

    example "comment attributes" do
      file_url = 'http://www.example.com/file.txt'
      allow_any_instance_of(Attachment).to receive(:url).and_return(file_url)

      do_request
      expect(json).to eq(
        comment: {
          event_start_at: event_start_at.iso8601(3),
          created_at: Time.current.iso8601(3),
          body: body,
          user: {
            name: teacher.name,
            avatar_url: nil,
            id: teacher.user.id
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
end
