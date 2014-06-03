require 'spec_helper'

describe Api::V1::Teacher::PollsController do

  describe "PATCH /api/v1/teacher/polls/:uuid/release.json" do

    it_behaves_like "API authentication required"

    context "authenticated" do
      let(:poll) { create :poll }

      def do_action
        patch "/api/v1/teacher/polls/#{poll.uuid}/release.json", auth_params(:teacher)
      end

      before do
        Timecop.freeze
        expect_any_instance_of(EventPusher).to receive(:release_poll).with(poll)
        do_action
        poll.reload
      end

      it { expect(response.status).to eq(200) }
      it { expect(poll.status).to eq "released" }
      it { expect(poll.released_at.to_i).to eq Time.now.to_i }

      context "releasing the same poll again" do
        before do
          EventPusher.any_instance.stub(:release_poll)
          do_action
        end

        it { expect(response.code).to eq '304' }
      end
    end

  end
end
