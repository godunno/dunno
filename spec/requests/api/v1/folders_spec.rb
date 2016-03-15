require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Folders" do
  parameter :user_email, "User's email", required: true
  parameter :user_token, "User's authentication_token", required: true
  let!(:profile) { create(:profile) }
  let(:user_email) { profile.email }
  let(:user_token) { profile.authentication_token }
  let(:course) { create(:course, teacher: profile) }

  let(:json) { JSON.parse(response_body) }

  get "/api/v1/folders.json" do
    parameter :course_id, "Course in which to find the folders", required: true

    let(:course_id) { course.uuid }
    let!(:folder) { create(:folder, course: course) }

    example_request "returns the folders attributes", document: :public do
      expect(json).to eq([
        "id" => folder.id,
        "name" => folder.name,
        "course_id" => course_id
      ])
    end
  end

  get "/api/v1/folders/:id.json" do
    parameter :id, "Folder's id", required: true

    let(:id) { folder.id }
    let!(:folder) { create(:folder, course: course, medias: [media]) }
    let(:media) { create(:media) }

    example_request "returns the folder attributes along with its medias", document: :public do
      expect(json).to eq(
        "folder" => {
          "id" => folder.id,
          "name" => folder.name,
          "course_id" => course.uuid,
          "medias" => [
            "id"          => media.id,
            "uuid"        => media.uuid,
            "title"       => media.title,
            "description" => media.description,
            "preview"     => media.preview,
            "type"        => media.type,
            "thumbnail"   => media.thumbnail,
            "filename"    => nil,
            "tag_list"    => media.tag_list,
            "url"         => media.url,
            "folder_id"   => folder.id,
            "created_at"  => media.created_at.iso8601(3),
            "courses"     => []
          ]
        }
      )
    end
  end

  post "/api/v1/folders.json" do
    parameter :name, "Folder's name.",
              required: true,
              scope: :folder
    parameter :course_id, "Folder's course.", required: true, scope: :folder

    response_field :id, "Folder's id"
    response_field :name, "Folder's name"
    response_field :course_id, "Folder's course's id"

    let(:raw_post) { params.to_json }

    let(:name) { 'Apostila 2015' }
    let(:course_id) { course.uuid }

    context "valid" do
      let(:folder) { Folder.last }

      before { Timecop.freeze }
      after { Timecop.return }

      example "creates a new Folder" do
        expect { do_request }.to change { Folder.count }.by(1)
      end

      example_request "sets the right headers and status" do
        expect(response_headers["Content-Type"]).to eq "application/json; charset=utf-8"
        expect(response_status).to eq 200
      end

      example_request "creates a Folder for the course" do
        expect(course.reload.folders).to eq [folder]
      end

      example_request "returns the Folder attributes", document: :public do
        expect(json).to eq(
          "folder" => {
            "id" => folder.id,
            "name" => folder.name,
            "course_id" => course_id
          }
        )
      end
    end

    context "invalid attachment" do
      let(:name) { nil }

      example_request "returns errors for invalid FOlder" do
        expect(json).to eq(
          "errors" => {
            "name" => ["error" => "blank"]
          }
        )
      end
    end
  end

  delete "/api/v1/folders/:id.json" do
    let!(:folder) { create(:folder, course: course) }
    let(:id) { folder.id }

    let(:raw_post) { params.to_json }

    context "successfully destroying folder" do
      example "deletes a folder" do
        expect { do_request }.to change { Folder.count }.by(-1)
        expect(Folder.exists?(folder.id)).to be false
      end
    end

    context "trying to destroy as student" do
      let(:course) { create(:course, students: [profile]) }

      example_request "fails to delete a folder" do
        expect(response_status).to eq 403
      end
    end

    context "trying to destroy when not registered in the course" do
      let(:course) { create(:course) }

      example "fails to delete a folder" do
        expect { do_request }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
