require 'spec_helper'

describe TopicsRatingCreator do
  let!(:topic_one) { create(:topic, description: "My first topic") }
  let!(:topic_two) { create(:topic, description: "My second topic") }
  let!(:student) { create(:student) }

  describe "#create" do

    context "with valid topics" do
      let!(:topics_params) do
        {
          topics: [
            {
              id: topic_one.id,
              ratings_attributes: [
                {
                  value: 0.5,
                  student_id: student.id
                }
              ]
            },
            {
              id: topic_two.id,
              ratings_attributes: [
                {
                  value: 0.9,
                  student_id: student.id
                }
              ]
            }
          ]
        }
      end

      let!(:topic_rating_creator) { TopicsRatingCreator.new(topics_params[:topics]) }

      it { expect(topic_rating_creator.create).to be_true }

      context "creation of rating" do

        before(:each) do
          topic_rating_creator.create
        end


        it { expect(topic_one.ratings.first.value).to eq(0.5) }
        it { expect(topic_two.ratings.first.value).to eq(0.9) }

        it { expect(topic_one.ratings.size).to eq(1) }
        it { expect(topic_two.ratings.size).to eq(1) }
      end


    end

    context "with invalid topics" do
      let!(:topics_params) do
        {
          topics: [
            {
              id: topic_one.id,
              ratings_attributes: [
                {
                  value: 0.5,
                  student_id: student.id
                }
              ]
            },
            {
              id: "2342",
              ratings_attributes: [
                {
                  value: 0.9,
                  student_id: student.id
                }
              ]
            }
          ]
        }
      end

      let!(:topic_rating_creator) { TopicsRatingCreator.new(topics_params[:topics]) }

      it do
        expect do
          topic_rating_creator.create
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end