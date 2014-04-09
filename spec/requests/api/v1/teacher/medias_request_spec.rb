require 'spec_helper'

describe Api::V1::Teacher::MediasController do
  describe "PATCH release" do
    context "authenticated" do
      let(:media) { create :media }

      def do_action
        patch "/api/v1/teacher/medias/#{media.uuid}/release", auth_params(:teacher)
      end

      before do
        expect_any_instance_of(EventPusher).to receive(:release_media).with(media)
        do_action
        media.reload
      end

      it "should update the poll status to released" do
        expect(media.status).to eq "released"
      end


      context "releasing the same poll again" do
        before do
          EventPusher.any_instance.stub(:release_media)
          do_action
        end

        it { expect(response.code).to eq '400' }
      end
    end
  end
end
