require 'spec_helper'

describe Form::EventForm do
  describe "validations" do
    [:title, :start_at, :duration, :course].each do |attr|
      it { should validate_presence_of(attr) }
    end
  end

  let(:course) { create(:course) }
  let(:event_form) { Form::EventForm.new(event) }
  let(:valid_event_hash) { { course_id: course.id, title: "NEW EVENT", start_at: Time.now, duration: '2:00' } }

  describe "creating" do

    context "valid event" do
      let(:event) { valid_event_hash }
      before(:each) { event_form.save }

      it { expect(event_form).to be_valid }
      it { expect(event_form.model).to be_persisted }
      it { expect(event_form.model.title).to eq(event[:title]) }
      it { expect(event_form.model.start_at).to eq(event[:start_at]) }
      it { expect(event_form.model.duration).to eq(event[:duration]) }

      context "with nested models" do
        let(:topic) { {description: "NEW DESCRIPTION"} }
        let(:event) do
          valid_event_hash.merge({topics: [topic]})
        end

        it { expect(event_form).to be_valid }
        it { expect(event_form.model.topics.first.description).to eq(topic[:description]) }
      end
    end

    context "invalid" do
      let(:event) { {} }

      context "event" do
        before do
          event_form.save
        end

        it { expect(event_form).not_to be_valid }
        it { expect(event_form.errors).to include(:title) }
        it { expect(event_form.errors).to include(:start_at) }
        it { expect(event_form.errors).to include(:duration) }
      end

      context "nested models" do
        let(:topic) { {} }
        let(:topic_error) { :topic_error }
        let(:event) do
          {
            topics: [topic]
          }
        end

        before do
          error = ActiveModel::Errors.new(:topic)
          error.add(topic_error, topic_error.to_s)
          Form::TopicForm.any_instance.stub(:valid?).and_return(false)
          Form::TopicForm.any_instance.stub(:errors).and_return(error)
          event_form.save
        end

        it { expect(event_form).not_to be_valid }
        it { expect(event_form.errors).to include(topic_error) }
      end

      context "trying to change nested model's timeline" do
        let(:existing_topic) { create(:topic) }
        let(:topic) { {uuid: existing_topic.uuid, description: 'UPDATED DESCRIPTION'} }
        let(:event) do
          valid_event_hash.merge({
            topics: [topic]
          })
        end
        before(:each) { event_form.save }

        it { expect(event_form).not_to be_valid }
        it { expect(event_form.errors).to include(:timeline) }
        it { expect(event_form.model.title).not_to eq(event[:title]) }
        it { expect(existing_topic.reload.description).not_to eq(topic[:description]) }
      end
    end
  end

  describe "updating" do
    let(:existing_event) { create(:event) }
    context "valid event" do
      let(:event) do
        valid_event_hash.merge({
          uuid: existing_event.uuid,
          title: 'UPDATED TITLE',
        })
      end
      before(:each) { event_form.save }

      it { expect(event_form).to be_valid }
      it { expect(existing_event.reload.title).to eq(event[:title]) }

      context "with nested models" do
        let(:existing_topic) { create(:topic, timeline: existing_event.timeline) }
        let(:topic) { {uuid: existing_topic.uuid, description: 'UPDATED DESCRIPTION'} }
        let(:event) do
          valid_event_hash.merge({
            uuid: existing_event.uuid,
            topics: [topic]
          })
        end

        it { expect(event_form).to be_valid }
        it { expect(existing_topic.reload.description).to eq(topic[:description]) }
      end
    end

    context "invalid" do
      let(:event) { {uuid: existing_event.uuid, title: nil, start_at: nil, duration: nil} }

      context "event" do
        before do
          event_form.save
        end

        it { expect(event_form).not_to be_valid }
        it { expect(event_form.errors).to include(:title) }
        it { expect(event_form.errors).to include(:start_at) }
        it { expect(event_form.errors).to include(:duration) }
      end

      context "nested models" do
        let(:existing_topic) { create(:topic, timeline: existing_event.timeline) }
        let(:topic) { {uuid: existing_topic.uuid} }
        let(:topic_error) { :topic_error }
        let(:event) do
          {
            uuid: existing_event.uuid,
            title: 'UPDATED TITLE',
            topics: [topic]
          }
        end

        before do
          error = ActiveModel::Errors.new(:topic)
          error.add(topic_error, topic_error.to_s)
          Form::TopicForm.any_instance.stub(:valid?).and_return(false)
          Form::TopicForm.any_instance.stub(:errors).and_return(error)
          event_form.save
        end

        it { expect(event_form).not_to be_valid }
        it { expect(event_form.errors).to include(topic_error) }
        it { expect(existing_event.reload.title).not_to eq(event[:title]) }
        it { expect(existing_topic.reload.description).not_to eq(topic[:description]) }
      end

      context "trying to change nested model's timeline" do
        let(:existing_topic) { create(:topic) }
        let(:topic) { {uuid: existing_topic.uuid, description: 'UPDATED DESCRIPTION'} }
        let(:event) do
          valid_event_hash.merge({
            uuid: existing_event.uuid,
            topics: [topic]
          })
        end
        before(:each) { event_form.save }

        it { expect(event_form).not_to be_valid }
        it { expect(event_form.errors).to include(:timeline) }
        it { expect(existing_event.reload.title).not_to eq(event[:title]) }
        it { expect(existing_topic.reload.description).not_to eq(topic[:description]) }
      end
    end

    context "destroying nested models" do
      let(:existing_topic) { create(:topic, timeline: existing_event.timeline) }
      let(:topic) { {uuid: existing_topic.uuid, _destroy: true} }
      let(:event) do
        valid_event_hash.merge({
          uuid: existing_event.uuid,
          topics: [topic]
        })
      end

      it do
        expect { event_form.save }.
          to change { existing_event.reload.topics.to_a }.
          from([existing_topic]).
          to([])
      end
    end
  end
end
