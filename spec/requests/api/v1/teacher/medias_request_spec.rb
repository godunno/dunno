require 'spec_helper'

describe Api::V1::Teacher::MediasController do
  describe "POST /api/v1/teacher/medias.json", :vcr do
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
          }.merge(auth_params(:teacher)).to_json
        end

        before { do_action }
        subject { Media.last }

        it { expect(last_response.status).to eq(200) }
        it { expect(json["uuid"]).to eq(subject.uuid) }
        it { expect(subject.url).to eq(url) }
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
        let(:file) { uploaded_file("image.jpg", "image/jpeg") }
        let(:params_hash) do
          {
            "file" => file
          }.merge(auth_params(:teacher))
        end

        before { do_action }
        subject { Media.last }

        it { expect(last_response.status).to eq(200) }
        it { expect(json["uuid"]).to eq(subject.uuid) }
        it { expect(subject.file_identifier).to eq(file.original_filename) }
        it { expect(json["preview"]).to eq(subject.preview) }
        it "should have the correct preview" do
          expect(json["preview"]).to eq(
            "url" => subject.file.url,
            "title" => file.original_filename
          )
        end
      end

      context "creating invalid media" do
        let(:params_hash) do
          {
            "media" => {
            }
          }.merge(auth_params(:teacher)).to_json
        end

        before { do_action }
        subject { Media.last }

        it { expect(last_response.status).to eq(422) }
        it { expect(json["errors"]).to have_key("url") }
        it { expect(json["errors"]).to have_key("file") }
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
