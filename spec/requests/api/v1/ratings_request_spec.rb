require 'spec_helper'

describe Api::V1::RatingsController do
  describe "POST /api/v1/ratings" do

    let(:student) { create(:student) }
    let(:rating) { build :rating }

    it_behaves_like "API authentication required"

    context "authenticated" do

      context "with valid thermometer id" do

        let!(:thermometer) { create :thermometer }

        before do
          post '/api/v1/ratings', { rating: rating.attributes }.merge(
            { thermometer_id: thermometer.uuid }).merge(
            auth_params(student))
        end

        subject { Rating.first }

        it { expect(response.code).to eq '201' }
        it { expect(subject.value).to eq rating.value }
        it { expect(subject.rateable).to eq thermometer }
        it { expect(subject.student).to eq student }
      end

      context "with any invalid thermometer id" do

      end
    end
  end
end
