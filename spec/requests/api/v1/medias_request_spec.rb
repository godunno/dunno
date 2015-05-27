require 'spec_helper'

describe Api::V1::MediasController do
  describe "GET /api/v1/medias.json", :elasticsearch do

    let!(:media_from_another_course) { create :media, topics: [create(:topic)] }
    let!(:course) { create :course }
    let!(:event) { create :event, course: course }
    let!(:topic) { create :topic, event: event }
    let!(:student) { create :student, courses: [course] }

    let(:params_hash) { { course_uuid: course.uuid } }

    def do_action
      get "/api/v1/medias.json", params_hash.merge(auth_params(student))
    end

    context "media with URL" do
      let!(:media) { create :media_with_url, topics: [topic] }

      before do
        refresh_index!
        do_action
      end

      it { expect(last_response.status).to eq(200) }
      it "should return the teacher's medias" do
        expect(json["medias"]).to eq(
          [{
            "id"          => media.id,
            "uuid"        => media.uuid,
            "title"       => media.title,
            "description" => media.description,
            "category"    => media.category,
            "preview"     => media.preview,
            "type"        => media.type,
            "thumbnail"   => media.thumbnail,
            "filename"    => nil,
            "tag_list"    => media.tag_list,
            "url"         => media.url,
            "courses"     => [
              {
                "uuid" => course.uuid,
                "name" => course.name,
                "events"   => [
                  {
                    "uuid"     => event.uuid,
                    "start_at" => event.start_at.utc.iso8601
                  }
                ]
              }
            ]
          }]
        )
      end
    end

    context "media with file" do
      let(:media) { create :media_with_file, topics: [topic] }

      before do
        Timecop.freeze
        media.save!
        refresh_index!
        do_action
      end

      after { Timecop.return }

      it { expect(last_response.status).to eq(200) }
      it "should return the teacher's medias" do
        expect(json["medias"]).to eq(
          [{
            "id"          => media.id,
            "uuid"        => media.uuid,
            "title"       => media.title,
            "description" => nil,
            "category"    => nil,
            "preview"     => nil,
            "type"        => media.type,
            "thumbnail"   => nil,
            "filename"    => media.original_filename,
            "tag_list"    => media.tag_list,
            "url"         => media.url,
            "courses"     => [
              {
                "uuid" => course.uuid,
                "name" => course.name,
                "events"   => [
                  {
                    "uuid"     => event.uuid,
                    "start_at" => event.start_at.utc.iso8601
                  }
                ]
              }
            ]
          }]
        )
      end
    end

    context "searching" do
      let!(:awesome_media) { create :media_with_url, title: "awesome", topics: [create(:topic, event: event)] }
      let!(:boring_media)  { create :media_with_url, title: "boring", topics: [create(:topic, event: event)] }
      let(:params_hash) do
        {
          q: awesome_media.title,
          course_uuid: course.uuid
        }
      end

      before do
        refresh_index!
        do_action
      end

      it { expect(last_response.status).to eq(200) }
      it "should return only the searched terms" do
        expect(json["medias"]).to eq(
          [{
            "id"          => awesome_media.id,
            "uuid"        => awesome_media.uuid,
            "title"       => awesome_media.title,
            "description" => awesome_media.description,
            "category"    => awesome_media.category,
            "preview"     => awesome_media.preview,
            "type"        => awesome_media.type,
            "thumbnail"   => awesome_media.thumbnail,
            "filename"    => nil,
            "tag_list"    => awesome_media.tag_list,
            "url"         => awesome_media.url,
            "courses"     => [
              {
                "uuid" => course.uuid,
                "name" => course.name,
                "events"   => [
                  {
                    "uuid"     => event.uuid,
                    "start_at" => event.start_at.utc.iso8601
                  }
                ]
              }
            ]
          }]
        )
      end
    end

    context "paginating" do
      let!(:medias) do
        (1..11).map { create(:media_with_url, topics: [create(:topic, event: event)]) }.reverse
      end

      let(:medias_uuids) { medias.map(&:uuid) }

      subject { json["medias"].map { |media| media["uuid"] } }

      context "first page" do
        let(:params_hash) do
          {
            page: 1,
            course_uuid: course.uuid
          }
        end
        before do
          refresh_index!
          do_action
        end

        it { expect(subject).to eq(medias_uuids[0..9]) }
        it { expect(json["next_page"]).to eq(2) }
        it { expect(json["current_page"]).to eq(1) }
        it { expect(json["previous_page"]).to be_nil }
      end

      context "second page" do
        let(:params_hash) do
          {
            page: 2,
            course_uuid: course.uuid
          }
        end
        before do
          refresh_index!
          do_action
        end

        it { expect(subject).to eq(medias_uuids[10..-1]) }
        it { expect(json["next_page"]).to be_nil }
        it { expect(json["current_page"]).to eq(2) }
        it { expect(json["previous_page"]).to eq(1) }
      end
    end
  end
end
