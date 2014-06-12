require 'spec_helper'

describe Api::V1::Teacher::MediasController do
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

      it { expect(last_response.status).to eq(200) }
      it { expect(media.status).to eq "released" }
      it { expect(media.released_at.to_i).to eq Time.now.to_i }


      context "releasing the same poll again" do
        before do
          EventPusher.any_instance.stub(:release_media)
          do_action
        end

        it { expect(last_response.status).to eq(304) }
      end
    end
  end
end
