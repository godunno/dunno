require 'spec_helper'

describe CreateCourseFromTemplate do
  let(:published_event_with_text_topics) do
    build :event, :published,
          topics: [public_text_topic, personal_text_topic],
          course: nil,
          classroom: 'some classroom'
  end
  let(:public_text_topic) do
    build :topic,
          description: "public topic description",
          done: false,
          order: 2,
          event: nil
  end
  let(:personal_text_topic) do
    build :topic, :personal,
          description: "personal topic description",
          done: true,
          order: 1,
          event: nil
  end

  let(:draft_event_with_media_topic) do
    build(:event, :draft, topics: [media_topic], course: nil)
  end
  let(:media_topic) { build(:topic, media: create(:media_with_url)) }

  let(:canceled_event_with_comments) do
    build(:event, :canceled, comments: [build(:comment, event: nil)], course: nil)
  end

  let(:template) do
    create :course,
           name: "Template course",
           start_date: '2015-01-01',
           end_date: '2015-02-01',
           events: [
             published_event_with_text_topics,
             draft_event_with_media_topic,
             canceled_event_with_comments
           ]
  end

  let(:every_tuesday) { WeeklySchedule.new(weekday: 2, start_time: "09:30", end_time: "11:00") }
  let(:every_thursday) { WeeklySchedule.new(weekday: 4, start_time: "13:00", end_time: "14:00") }

  let(:start_date) { Date.parse('2016-05-01') }

  let(:teacher) { create(:profile) }
  let(:student) { create(:profile) }

  let(:service) do
    CreateCourseFromTemplate.new(template,
                                 teacher: teacher,
                                 students: [student],
                                 weekly_schedules: [
                                   every_tuesday,
                                   every_thursday
                                 ],
                                 start_date: start_date
                                )
  end

  let(:new_course) { service.create }

  it { expect(new_course.name).to eq template.name }
  it { expect(new_course.start_date).to eq start_date }
  it "has the same number of days as the template" do
    end_date = start_date + (template.end_date - template.start_date).to_i.days
    expect(new_course.end_date).to eq end_date
    expect(new_course.end_date).to eq Date.parse('2016-06-01')
  end
  it { expect(new_course.events.count).to be 3 }
  it { expect(new_course.weekly_schedules).to eq [every_tuesday, every_thursday] }
  it { expect(new_course.teacher).to eq teacher }
  it { expect(new_course.students).to eq [student] }

  describe "published event with text topics" do
    let(:event) { new_course.events[0] }

    it { expect(event.start_at).to eq Time.zone.parse('2016-05-03 9:30') }
    it { expect(event.end_at).to eq Time.zone.parse('2016-05-03 11:00') }
    it { expect(event.classroom).to eq published_event_with_text_topics.classroom }
    it { expect(event).to be_published }
    it { expect(event.topics.count).to be 2 }

    describe "public text topic" do
      let(:topic) { event.topics.find_by(personal: false) }

      it { expect(topic.description).to eq public_text_topic.description }
      it { expect(topic.order).to eq public_text_topic.order }
      it { expect(topic.done).to eq public_text_topic.done }
    end

    describe "personal text topic" do
      let(:topic) { event.topics.find_by(personal: true) }

      it { expect(topic.description).to eq personal_text_topic.description }
      it { expect(topic.order).to eq personal_text_topic.order }
      it { expect(topic.done).to eq personal_text_topic.done }
    end
  end

  describe "draft event with media topic" do
    let(:event) { new_course.events[1] }

    it { expect(event.start_at).to eq Time.zone.parse('2016-05-05 13:00') }
    it { expect(event.end_at).to eq Time.zone.parse('2016-05-05 14:00') }
    it { expect(event.classroom).to eq draft_event_with_media_topic.classroom }
    it { expect(event).to be_draft }
    it { expect(event.topics.count).to be 1 }

    describe "media topic" do
      let(:topic) { event.topics.first }

      it { expect(topic.description).to eq media_topic.description }
      it { expect(topic.order).to eq media_topic.order }
      it { expect(topic.done).to eq media_topic.done }
      it { expect(topic.media).to eq media_topic.media }
    end
  end

  describe "canceled event with comments" do
    let(:event) { new_course.events[2] }

    it { expect(event.start_at).to eq Time.zone.parse('2016-05-10 9:30') }
    it { expect(event.end_at).to eq Time.zone.parse('2016-05-10 11:00') }
    it { expect(event.classroom).to eq canceled_event_with_comments.classroom }
    it { expect(event).to be_canceled }
    it { expect(event.topics.count).to be 0 }
    it { expect(event.comments.count).to be 0 }
  end

  context "template course without end date" do
    let(:template) do
      create :course,
             name: "Template course",
             end_date: nil,
             events: [published_event_with_text_topics]
    end

    it { expect(new_course.end_date).to be_nil }
    it { expect(new_course.events.count).to be 1 }
  end
end
