require 'spec_helper'

describe Form::TopicForm do
  context "without media" do
    let(:description) { "Awesome video" }

    context "creating topic" do
      let(:topic) { attributes_for(:topic, description: description).with_indifferent_access }
      let(:topic_form) { Form::TopicForm.new topic }

      before { topic_form.save! }

      it { expect(topic_form.model.description).to eq(description) }
    end

    context "updating topic" do
      let(:topic) { create :topic, description: "Old description" }
      let(:topic_form) { Form::TopicForm.new topic.attributes.merge(description: description).with_indifferent_access }

      before { topic_form.save! }

      it { expect(topic_form.model.description).to eq(description) }
    end
  end

  context "with media" do
    let(:description) { "Awesome video" }

    context "creating topic" do
      let(:media) { create :media, title: 'Original media title' }
      let(:topic) { attributes_for(:topic, description: description, media_id: media.uuid).with_indifferent_access }
      let(:topic_form) { Form::TopicForm.new topic }

      before { topic_form.save! }

      it { expect(topic_form.model.description).to be_nil }
      it { expect(media.reload.title).to eq(description) }

      context "without description" do
        let(:description) { nil }

        it { expect(topic_form.model.description).to be_nil }
        it { expect(media.reload.title).to eq('Original media title') }
      end
    end

    context "updating topic" do
      let(:new_description) { "Great amounts of awesomeness" }
      let(:media) { create :media, title: description }
      let(:topic) { create :topic, description: nil, media: media }
      let(:topic_form) { Form::TopicForm.new topic.attributes.merge(description: new_description, media_id: media.uuid).with_indifferent_access }

      before { topic_form.save! }

      it { expect(topic_form.model.description).to be_nil }
      it { expect(media.reload.title).to eq(new_description) }
    end
  end
end
