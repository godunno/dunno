require 'spec_helper'

describe Api::V1::Teacher::EventsController do

  let(:teacher) { create(:teacher) }
  let(:course) { create(:course, teacher: teacher) }
  let(:event) { create(:event, course: course) }

  let(:pusher_events) { EventPusherEvents.new(teacher) }

  describe "PATCH #open" do

    def do_action
      patch "/api/v1/teacher/events/#{event.uuid}/open.json", auth_params(teacher)
    end

    before do
      Timecop.freeze
      CoursePusher.any_instance.should_receive(:open).once
      do_action
    end

    it { expect(response.status).to eq(200) }
    it { expect(json["uuid"]).to eq(event.uuid) }
    it { expect(event.reload.status).to eq('opened') }
    it { expect(event.reload.opened_at.to_i).to eq(Time.now.to_i) }
    it { expect(json["channel"]).to eq event.channel }
    it { expect(json["student_message_event"]).to eq pusher_events.student_message_event }
    it { expect(json["up_down_vote_message_event"]).to eq pusher_events.up_down_vote_message_event }

    context "opening event again" do
      before do
        Timecop.freeze(Time.now + 1)
        CoursePusher.any_instance.stub(:close)
        do_action
      end

      it { expect(response.status).to eq(304) }
      it { expect(event.reload.opened_at.to_i).not_to eq(Time.now.to_i) }
    end
  end

  describe "PATCH #close" do

    let(:event) { create(:event, status: 'opened') }

    def do_action
      patch "/api/v1/teacher/events/#{event.uuid}/close", auth_params(teacher)
    end

    before do
      Timecop.freeze
      EventPusher.any_instance.should_receive(:close).once
      do_action
    end

    it { expect(event.reload.status).to eq 'closed' }
    it { expect(event.reload.closed_at.to_i).to eq DateTime.now.to_i }

    context "closing event again" do
      before do
        Timecop.freeze(Time.now + 1)
        EventPusher.any_instance.stub(:close)
        do_action
      end

      it { expect(response.status).to eq(304) }
      it { expect(event.reload.closed_at.to_i).not_to eq(Time.now.to_i) }
    end
  end
end
