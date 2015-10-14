require 'spec_helper'

describe Api::V1::MediasController do
  let(:profile) { create(:profile) }

  describe "GET /api/v1/medias.json", :elasticsearch do
    let!(:media_from_another_profile) { create :media, profile: create(:profile) }

    let(:params_hash) { {} }

    def do_action
      get "/api/v1/medias.json", params_hash.merge(auth_params(profile))
    end

    context "media with URL" do
      let!(:course) { create :course, teacher: profile }
      let!(:event) { create :event, course: course }
      let!(:media) { create :media_with_url, profile: profile }
      let!(:topic) { create :topic, event: event, media: media }

      before do
        refresh_index!
        do_action
      end

      it { expect(last_response.status).to eq(200) }
      it "should return the profile's medias" do
        expect(json["medias"]).to eq(
          [{
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
      let(:media) { create :media_with_file, profile: profile }

      before do
        Timecop.freeze
        media.save!
        refresh_index!
        do_action
      end

      after { Timecop.return }

      it { expect(last_response.status).to eq(200) }
      it "should return the profile's medias" do
        expect(json["medias"]).to eq(
          [{
            "id"          => media.id,
            "uuid"        => media.uuid,
            "title"       => media.title,
            "description" => nil,
            "preview"     => nil,
            "type"        => media.type,
            "thumbnail"   => nil,
            "filename"    => media.original_filename,
            "tag_list"    => media.tag_list,
            "url"         => media.url,
            "courses"      => []
          }]
        )
      end
    end

    context "searching" do
      let!(:awesome_media) { create :media_with_url, title: "awesome", profile: profile }
      let!(:boring_media)  { create :media_with_url, title: "boring", profile: profile }
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
            "id"          => awesome_media.id,
            "uuid"        => awesome_media.uuid,
            "title"       => awesome_media.title,
            "description" => awesome_media.description,
            "preview"     => awesome_media.preview,
            "type"        => awesome_media.type,
            "thumbnail"   => awesome_media.thumbnail,
            "filename"    => nil,
            "tag_list"    => awesome_media.tag_list,
            "url"         => awesome_media.url,
            "courses"      => []
          }]
        )
      end
    end

    context "paginating" do
      let!(:medias) do
        (1..11).map do |i|
          create(:media_with_url, profile: profile, created_at: i.minutes.ago)
        end
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

  describe "POST /api/v1/medias.json", :vcr do
    def do_action
      post "/api/v1/medias.json", auth_params(profile).merge(params_hash).to_json
    end

    context "creating media with URL" do
      let(:url) { "http://silviosantosipsum.com/" }
      let(:params_hash) do
        {
          "media" => {
            "url" => url
          }
        }
      end

      before { do_action }
      subject { Media.last }

      it { expect(last_response.status).to eq(200) }
      it { expect(json["uuid"]).to eq(subject.uuid) }
      it { expect(json["id"]).to eq(subject.id) }
      it { expect(subject.url).to eq(url) }
      it { expect(subject.title).to eq("Silvio Santos Ipsum - O Lorem Ipsum do Silvio Santos") }
      it { expect(subject.description).to eq("Silvio Santos Ipsum. Um site voltado para desenvolvedores que precisam de um texto de exemplo para seus clientes.") }
      it { expect(subject.thumbnail).to eq("http://silviosantosipsum.com/images/silvio03.png") }
      it { expect(subject.profile).to eq(profile) }
      it { expect(json["preview"]).to eq(subject.preview) }
      it "should have the correct preview" do
        expect(json["preview"]).to eq(
          "url" => "http://silviosantosipsum.com/",
          "favicon" => "image/32x32/100/images/favicon.png",
          "title" => "Silvio Santos Ipsum - O Lorem Ipsum do Silvio Santos",
          "description" => "Silvio Santos Ipsum. Um site voltado para desenvolvedores que precisam de um texto de exemplo para seus clientes.",
          "images" => [
            { "src" => "http://silviosantosipsum.com/images/silvio03.png", "size" => [450, 450], "type" => "png" },
            { "src" => "http://silviosantosipsum.com/images/silvio01.png", "size" => [300, 524], "type" => "png" },
            { "src" => "http://silviosantosipsum.com/images/thumb-silvio-santos-ipsum.png", "size" => [237, 80], "type" => "png" },
            { "src" => "http://assets.pinterest.com/images/pidgets/pin_it_button.png", "size" => [40, 20], "type" => "png" }
          ],
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
        }
      end

      before { do_action }
      subject { Media.last }

      it { expect(last_response.status).to eq(200) }
      it { expect(json["uuid"]).to eq(subject.uuid) }
      it { expect(json["id"]).to eq(subject.id) }
      it { expect(subject.original_filename).to eq("document.doc") }
      it { expect(subject.title).to eq("document.doc") }
      it { expect(subject.profile).to eq(profile) }
    end

    context "creating invalid media" do
      let(:params_hash) do
        {
          "media" => {
            "original_filename" => "file.doc" # without file
          }
        }
      end

      before { do_action }
      subject { Media.last }

      it { expect(last_response.status).to eq(422) }
      it { expect(json["errors"]).to have_key("url") }
      it { expect(json["errors"]).to have_key("file_url") }
    end
  end

  describe "PATCH /api/v1/medias/:uuid.json" do
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
      patch "/api/v1/medias/#{media.uuid}.json", params_hash
        .merge(auth_params(profile)).to_json
    end

    context "successfully updating media" do
      let(:media) { create :media, profile: profile }

      before do
        do_action
        media.reload
      end

      it { expect(last_response.status).to eq(200) }
      it { expect(media.tag_list).to match_array(%w(history math science)) }
      it { expect(media.title).to eq(title) }
    end

    context "failing to update media" do
      let(:media) { create :media, title: "Old title", tag_list: "chemistry", profile: create(:profile) }

      it { expect { do_action }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  describe "DELETE /api/v1/medias/:uuid.json" do
    let(:media) { create :media, profile: profile }

    def do_action
      delete "/api/v1/medias/#{media.uuid}.json", auth_params(profile).to_json
    end

    before do
      do_action
    end

    it { expect(last_response.status).to eq(200) }
    it { expect(Media.find_by(id: media.id)).to be_nil }
  end
end
