require 'spec_helper'

describe Api::V1::Teacher::MediasController do
  describe "GET /api/v1/teacher/medias.json", :elasticsearch do

    let!(:teacher) { create :teacher }
    let!(:media_from_another_teacher) { create :media, teacher: create(:teacher) }

    let(:params_hash) { {} }

    def do_action
      get "/api/v1/teacher/medias.json", params_hash.merge(auth_params(teacher))
    end

    context "media with URL" do
      let!(:course) { create :course, teacher: teacher }
      let!(:event) { create :event, course: course }
      let!(:media) { create :media_with_url, teacher: teacher }
      let!(:topic) { create :topic, event: event, media: media }

      before do
        refresh_index!
        do_action
      end

      it { expect(last_response.status).to eq(200) }
      it "should return the teacher's medias" do
        expect(json["medias"]).to eq(
          [{
            "uuid"        => media.uuid,
            "title"       => media.title,
            "description" => media.description,
            "category"    => media.category,
            "preview"     => media.preview,
            "type"        => media.type,
            "thumbnail"   => media.thumbnail,
            "filename"    => nil,
            "released_at" => media.released_at,
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
      let(:media) { create :media_with_file, teacher: teacher }

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
            "uuid"        => media.uuid,
            "title"       => media.title,
            "description" => nil,
            "category"    => nil,
            "preview"     => nil,
            "type"        => media.type,
            "thumbnail"   => nil,
            "filename"    => media.original_filename,
            "released_at" => media.released_at,
            "tag_list"    => media.tag_list,
            "url"         => media.url,
            "courses"      => []
          }]
        )
      end
    end

    context "searching" do
      let!(:awesome_media) { create :media_with_url, title: "awesome", teacher: teacher }
      let!(:boring_media)  { create :media_with_url, title: "boring", teacher: teacher }
      let(:params_hash) do
        {
          q: awesome_media.title
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
            "uuid"        => awesome_media.uuid,
            "title"       => awesome_media.title,
            "description" => awesome_media.description,
            "category"    => awesome_media.category,
            "preview"     => awesome_media.preview,
            "type"        => awesome_media.type,
            "thumbnail"   => awesome_media.thumbnail,
            "filename"    => nil,
            "released_at" => awesome_media.released_at,
            "tag_list"    => awesome_media.tag_list,
            "url"         => awesome_media.url,
            "courses"      => []
          }]
        )
      end
    end

    context "paginating" do
      let!(:medias) do
        create_list(:media_with_url, 11, teacher: teacher).reverse
      end

      let(:medias_uuids) { medias.map(&:uuid) }

      subject { json["medias"].map { |media| media["uuid"] } }

      context "first page" do
        let(:params_hash) do
          {
            page: 1
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
            page: 2
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

  describe "POST /api/v1/teacher/medias.json", :vcr do
    let(:teacher) { create :teacher }
    it_behaves_like "API authentication required"
    context "authenticated" do

      def do_action
        post "/api/v1/teacher/medias.json", params_hash
      end

      context "creating media with URL" do
        let(:url) { "http://mussumipsum.com/" }
        let(:params_hash) do
          {
            "media" => {
              "url" => url
            }
          }.merge(auth_params(teacher)).to_json
        end

        before { do_action }
        subject { Media.last }

        it { expect(last_response.status).to eq(200) }
        it { expect(json["uuid"]).to eq(subject.uuid) }
        it { expect(subject.url).to eq(url) }
        it { expect(subject.title).to eq("Musum Ipsum") }
        it { expect(subject.description).to eq("O melhor Lorem Ipsum do mundis!") }
        it { expect(subject.thumbnail).to eq("http://mussumipsum.com/images/mussum_ipsum_og.jpg") }
        it { expect(subject.teacher).to eq(teacher) }
        it { expect(json["preview"]).to eq(subject.preview) }
        it "should have the correct preview" do
          expect(json["preview"]).to eq(
            "url" => "http://mussumipsum.com/",
            "favicon" => "images/icon_mussum.ico",
            "title" => "Musum Ipsum",
            "description" => "O melhor Lorem Ipsum do mundis!",
            "images" => [{
              "src" => "http://mussumipsum.com/images/mussum_ipsum_og.jpg",
              "size" => [450, 450],
              "type" => "jpeg"
            }],
            "videos" => []
          )
        end
      end

      context "creating media with file" do
        let(:file) { "document.doc" }
        let(:params_hash) do
          {
            "media" => {
              "file_url" => "uploads/#{file}",
              "original_filename" => file
            }
          }.merge(auth_params(teacher)).to_json
        end

        before { do_action }
        subject { Media.last }

        it { expect(last_response.status).to eq(200) }
        it { expect(json["uuid"]).to eq(subject.uuid) }
        it { expect(subject.original_filename).to eq("document.doc") }
        it { expect(subject.title).to eq("document.doc") }
        it { expect(subject.teacher).to eq(teacher) }
      end

      context "creating invalid media" do
        let(:params_hash) do
          {
            "media" => {
              "original_filename" => "file.doc" # without file
            }
          }.merge(auth_params(teacher)).to_json
        end

        before { do_action }
        subject { Media.last }

        it { expect(last_response.status).to eq(422) }
        it { expect(json["errors"]).to have_key("url") }
        it { expect(json["errors"]).to have_key("file_url") }
      end
    end
  end

  describe "PATCH release" do
    context "authenticated" do
      let(:media) { create :media }

      def do_action
        patch "/api/v1/teacher/medias/#{media.uuid}/release", auth_params(:teacher).to_json
      end

      before do
        Timecop.freeze
        expect_any_instance_of(EventPusher).to receive(:release_media).with(media)
        do_action
        media.reload
      end
      after { Timecop.return }

      it { expect(last_response.status).to eq(200) }
      it { expect(media.status).to eq "released" }
      it { expect(media.released_at.to_i).to eq Time.now.to_i }

      context "releasing the same poll again" do
        before do
          allow_any_instance_of(EventPusher).to receive(:release_media)
          do_action
        end

        it { expect(last_response.status).to eq(304) }
      end
    end
  end

  describe "PATCH /api/v1/teacher/medias/:uuid.json" do
    let(:media) { create :media }
    let(:tag_list) { "history, math, science" }
    let(:title) { "New title" }

    let(:params_hash) do
      {
        media: {
          tag_list: tag_list,
          title: title
        }
      }
    end

    def do_action
      patch "/api/v1/teacher/medias/#{media.uuid}.json", params_hash
        .merge(auth_params(:teacher)).to_json
    end

    before do
      do_action
      media.reload
    end

    it { expect(last_response.status).to eq(200) }
    it { expect(media.tag_list).to match_array(%w(history math science)) }
    it { expect(media.title).to eq(title) }
  end

  describe "DELETE /api/v1/teacher/medias/:uuid.json" do
    let(:media) { create :media }

    def do_action
      delete "/api/v1/teacher/medias/#{media.uuid}.json", auth_params(:teacher).to_json
    end

    before do
      do_action
    end

    it { expect(last_response.status).to eq(200) }
    it { expect(Media.find_by(id: media.id)).to be_nil }
  end

  describe "GET /api/v1/teacher/medias/preview.json", :vcr do

    let(:params_hash) do
      { url: url }
    end

    def do_action
      get "/api/v1/teacher/medias/preview.json", auth_params(:teacher).merge(params_hash)
    end

    before { do_action }
    subject { json }

    context "Website URL" do
      let(:url) { "http://mussumipsum.com/" }

      it { expect(last_response.status).to eq(200) }
      it "should have the correct response" do
        expect(json).to eq(
          "url" => "http://mussumipsum.com/",
          "favicon" => "images/icon_mussum.ico",
          "title" => "Musum Ipsum",
          "description" => "O melhor Lorem Ipsum do mundis!",
          "images" => [{
            "src" => "http://mussumipsum.com/images/mussum_ipsum_og.jpg",
            "size" => [450, 450],
            "type" => "jpeg"
          }],
          "videos" => []
        )
      end
    end
  end
end
