require 'spec_helper'

describe Form::EventForm do
  describe "validations" do
    %w(start_at end_at course).each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
  end

  let(:course) { create(:course) }
  let(:event_form) { Form::EventForm.new(event) }
  let(:valid_event_hash) { { course_id: course.id, start_at: Time.now, end_at: 2.hours.from_now, classroom: '201-A' } }

  describe "creating" do

    context "valid event" do
      let(:event) { valid_event_hash }
      before(:each) { event_form.save }

      it { expect(event_form).to be_valid }
      it { expect(event_form.model).to be_persisted }
      it { expect(event_form.model.start_at).to eq(event[:start_at]) }
      it { expect(event_form.model.end_at).to eq(event[:end_at]) }
      it { expect(event_form.model.classroom).to eq(event[:classroom]) }

      context "with nested models" do
        let(:topic) { {description: "NEW DESCRIPTION"} }
        let(:event) do
          valid_event_hash.merge(topics: [topic])
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
        it { expect(event_form.errors).to include(:start_at) }
        it { expect(event_form.errors).to include(:end_at) }
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
          allow_any_instance_of(Form::TopicForm).to receive(:valid?).and_return(false)
          allow_any_instance_of(Form::TopicForm).to receive(:errors).and_return(error)
          event_form.save
        end

        it { expect(event_form).not_to be_valid }
        it { expect(event_form.errors).to include(topic_error) }
      end

      context "trying to change nested model's timeline" do
        let(:existing_thermometer) { create(:thermometer) }
        let(:thermometer) { { uuid: existing_thermometer.uuid, content: 'UPDATED CONTENT' } }
        let(:event) do
          valid_event_hash.merge(thermometers: [thermometer])
        end
        before(:each) { event_form.save }

        it { expect(event_form).not_to be_valid }
        it { expect(event_form.errors).to include(:timeline) }
        it { expect(existing_thermometer.reload.content).not_to eq(thermometer[:content]) }
      end
    end
  end

  describe "updating" do
    let(:existing_event) { create(:event) }
    context "valid event" do
      let(:event) do
        valid_event_hash.merge({
          uuid: existing_event.uuid,
          start_at: existing_event.start_at + 1.hour
        })
      end
      before(:each) { event_form.save }

      it { expect(event_form).to be_valid }
      it { expect(existing_event.reload.start_at).to eq(event[:start_at]) }

      context "with nested models" do
        let(:existing_topic) { create(:topic, event: existing_event) }
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
      let(:event) { {uuid: existing_event.uuid, start_at: nil, end_at: nil} }

      context "event" do
        before do
          event_form.save
        end

        it { expect(event_form).not_to be_valid }
        it { expect(event_form.errors).to include(:start_at) }
        it { expect(event_form.errors).to include(:end_at) }
      end

      context "nested models" do
        let(:existing_topic) { create(:topic, event: existing_event) }
        let(:topic) { {uuid: existing_topic.uuid} }
        let(:topic_error) { :topic_error }
        let(:event) do
          {
            uuid: existing_event.uuid,
            topics: [topic]
          }
        end

        before do
          error = ActiveModel::Errors.new(:topic)
          error.add(topic_error, topic_error.to_s)
          allow_any_instance_of(Form::TopicForm).to receive(:valid?).and_return(false)
          allow_any_instance_of(Form::TopicForm).to receive(:errors).and_return(error)
          event_form.save
        end

        it { expect(event_form).not_to be_valid }
        it { expect(event_form.errors).to include(topic_error) }
        it { expect(existing_topic.reload.description).not_to eq(topic[:description]) }
      end

      context "trying to change nested model's timeline" do
        let(:existing_thermometer) { create(:thermometer) }
        let(:thermometer) { { uuid: existing_thermometer.uuid, content: 'UPDATED CONTENT' } }
        let(:event) do
          valid_event_hash.merge({
            uuid: existing_event.uuid,
            thermometers: [thermometer]
          })
        end
        before(:each) { event_form.save }

        it { expect(event_form).not_to be_valid }
        it { expect(event_form.errors).to include(:timeline) }
        it { expect(existing_thermometer.reload.content).not_to eq(thermometer[:content]) }
      end
    end

    context "destroying nested models" do
      let(:existing_topic) { create(:topic, event: existing_event) }
      let(:topic) { {uuid: existing_topic.uuid, _destroy: true} }
      let(:event) do
        valid_event_hash.merge({
          uuid: existing_event.uuid,
          topics: [topic]
        })
      end

      it do
        expect { event_form.save }
          .to change { existing_event.reload.topics.to_a }
          .from([existing_topic])
          .to([])
      end
    end
  end
end
