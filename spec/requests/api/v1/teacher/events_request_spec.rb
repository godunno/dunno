require 'spec_helper'

describe Api::V1::Teacher::EventsController do

  let(:teacher) { create(:teacher) }
  let(:course) { create(:course, teacher: teacher) }
  let(:event) { create(:event, course: course) }

  describe "PATCH #open" do

    def do_action
      patch "/api/v1/teacher/events/#{event.uuid}/open", auth_params(teacher)
    end

    before do
      Timecop.freeze
      do_action
    end

    it { expect(event.reload.status).to eq('opened') }
    it { expect(event.reload.opened_at.to_i).to eq(Time.now.to_i) }
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
  end
end
