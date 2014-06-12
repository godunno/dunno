require 'spec_helper'

describe Api::V1::AnswersController do
  describe "POST /api/v1/answers" do

    let(:student) { create(:student) }
    let(:option) { create(:option, poll: poll) }
    let(:poll) { create(:poll, timeline: event.timeline) }
    let(:event) { create(:event) }

    it_behaves_like "API authentication required"

    context "authenticated" do

      def do_action
        post '/api/v1/answers', { option_id: option.uuid }.merge(
          auth_params(student)).to_json
      end

      it_behaves_like "closed event"

      context "with valid option id" do

        before do
          do_action
        end

        subject { Answer.first }

        it { expect(last_response.status).to eq(201) }
        it { expect(subject.option).to eq option }
        it { expect(subject.student).to eq student }
      end

      context "with any invalid option id" do

      end
    end
  end
end
