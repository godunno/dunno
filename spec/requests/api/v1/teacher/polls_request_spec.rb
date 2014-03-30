require 'spec_helper'

describe Api::V1::Teacher::PollsController do

  describe "PATCH #release" do

    it_behaves_like "Dashboard authentication required"

    context "authenticated" do
      let(:poll) { create :poll }

      def do_action
        patch "/api/v1/teacher/polls/#{poll.uuid}/release", auth_params(:teacher)
      end

      before do
        expect_any_instance_of(EventPusher).to receive(:release_poll).with(poll)
        do_action
        poll.reload
      end

      it "should update the poll status to released" do
        expect(poll.status).to eq "released"
      end


      context "releasing the same poll again" do
        before do
          EventPusher.any_instance.stub(:release_poll)
          do_action
        end

        it { expect(response.code).to eq '400' }
      end
    end

  end
end
