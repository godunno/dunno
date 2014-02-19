require 'spec_helper'

describe Api::V1::RatingsController do
  describe "POST /api/v1/topics/rating" do
    it_behaves_like "API authentication required"

    context "authenticated" do

      context "with valid topics ids" do

      end

      context "with any invalid topic id" do

      end
    end
  end
end