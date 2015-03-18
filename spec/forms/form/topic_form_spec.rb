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
      let(:media) { create :media, title: nil }
      let(:topic) { attributes_for(:topic, description: description, media_id: media.uuid).with_indifferent_access }
      let(:topic_form) { Form::TopicForm.new topic }

      before { topic_form.save! }

      it { expect(topic_form.model.description).to be_nil }
      it { expect(media.reload.title).to eq(description) }
    end

    context "updating topic" do
      let(:media) { create :media, title: description }
      let(:topic) { create :topic, description: nil, media: media }
      let(:topic_form) { Form::TopicForm.new topic.attributes.merge(media_id: media.uuid).with_indifferent_access }

      before { topic_form.save! }

      it { expect(topic_form.model.description).to be_nil }
      it { expect(media.reload.title).to eq(description) }
    end
  end
end
