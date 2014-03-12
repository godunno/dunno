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
        expect_any_instance_of(EventPusher).to receive(:release_poll).with(poll)
        patch :release, id: poll.uuid
        poll.reload
      end

      it "should update the poll status to released" do
        expect(poll.status).to eq "released"
      end


      context "releasing the same poll again" do
        before do
          EventPusher.any_instance.stub(:release_poll)
          patch :release, id: poll.uuid
        end

        it { expect(response.code).to eq '400' }
      end
    end

  end
end
