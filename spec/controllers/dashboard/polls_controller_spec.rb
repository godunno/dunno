require 'spec_helper'

describe Dashboard::PollsController do
  before do
    sign_in :teacher, create(:teacher)
  end

  describe "PATCH #release" do

    it_behaves_like "Dashboard authentication required"

    context "authenticated" do
      let(:poll) { create :poll }

      before do
        EventPusher.any_instance.should_receive(:release_poll).with(poll).once
        patch :release, id: poll.uuid
        poll.reload
      end

      it "should update the poll status to released" do
        expect(poll.status).to eq "released"
      end
    end

  end
end
