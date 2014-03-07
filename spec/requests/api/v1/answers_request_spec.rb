require 'spec_helper'

describe Api::V1::AnswersController do
  describe "POST /api/v1/answers" do

    let(:student) { create(:student) }
    let(:option) { create(:option) }

    it_behaves_like "API authentication required"

    context "authenticated" do

      context "with valid option id" do

        before do
          post '/api/v1/answers', { option_id: option.uuid }.merge(
            auth_params(student))
        end

        subject { Answer.first }

        it { expect(response.code).to eq '201' }
        it { expect(subject.option).to eq option }
        it { expect(subject.student).to eq student }
      end

      context "with any invalid option id" do

      end
    end
  end
end
