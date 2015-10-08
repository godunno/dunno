require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Attachments" do
  parameter :user_email, "User's email", required: true
  parameter :user_token, "User's authentication_token", required: true
  let!(:profile) { create(:profile) }
  let(:user_email) { profile.email }
  let(:user_token) { profile.authentication_token }

  let(:json) { JSON.parse(response_body) }

  post "/api/v1/attachments.json" do
    parameter :original_filename, "Original filename before uploading to S3.",
              required: true,
              scope: :attachment
    parameter :file_url, "File's path on S3.", required: true, scope: :attachment
    parameter :file_size, "File's size.", required: true, scope: :attachment

    response_field :id, "Attachment's id"
    response_field :url, "Authenticated URL to file on S3."
    response_field :original_filename, "Original filename before uploading to S3."
    response_field :file_size, "File's size"

    let(:raw_post) { params.to_json }

    let(:original_filename) { 'text.txt' }
    let(:file_url) { 'path/to/text.txt' }
    let(:file_size) { 12345 }

    context "valid attachment" do
      let(:attachment) { Attachment.last }

      example "creates a new Attachment" do
        expect { do_request }.to change { Attachment.count }.by(1)
      end

      example_request "sets the right headers and status" do
        expect(response_headers["Content-Type"]).to eq "application/json; charset=utf-8"
        expect(response_status).to eq 200
      end

      example_request "creates an Attachment for the current user" do
        expect(attachment.profile).to eq profile
      end

      example_request "returns the Attachment attributes", document: :public do
        expect(json).to eq(
          "attachment" => {
            "id" => attachment.id,
            "url" => attachment.file.url,
            "original_filename" => original_filename,
            "file_size" => file_size
          }
        )
      end
    end

    context "invalid attachment" do
      let(:original_filename) { nil }

      example_request "returns errors for invalid Attachment" do
        expect(json).to eq(
          "errors" => {
            "original_filename" => ["error" => "blank"]
          }
        )
      end
    end
  end

  delete "/api/v1/attachments/:id.json" do
    let(:attachment) { create(:attachment, profile: profile) }
    let(:id) { attachment.id }

    let(:raw_post) { params.to_json }

    example "deletes an attachment" do
      attachment
      expect { do_request }.to change { Attachment.count }.by(-1)
      expect(Attachment.exists?(attachment.id)).to be false
    end
  end
end
