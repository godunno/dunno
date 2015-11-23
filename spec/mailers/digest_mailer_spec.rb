require 'spec_helper'

RSpec.describe DigestMailer, type: :mailer do
  let(:profile) { create(:profile) }

  let(:teacher) { create(:profile) }
  let(:new_student) { create(:profile) }
  let(:course_as_student) { create(:course, teacher: teacher) }
  let(:course_as_teacher) { create(:course, teacher: profile, students: [new_student]) }
  let(:blocked_course) { create(:course, students: [profile]) }
  let(:event) { create(:event, course: course_as_student) }
  let(:comment) { create(:comment, event: event) }
  let(:event) do
    create :event, :published,
           course: course_as_student,
           topics: [topic, personal_topic],
           start_at: Time.zone.parse('2015-01-01 14:00')
  end
  let(:topic) { create(:topic) }
  let(:personal_topic) { create(:topic, :personal, description: 'Personal topic') }
  let(:comment_from_blocked_course) do
    create :comment,
           body: 'Blocked comment',
           event: create(:event, course: blocked_course)
  end
  let!(:new_comment_notification_from_blocked_course) do
    create :system_notification, :new_comment,
           notifiable: comment_from_blocked_course,
           profile: profile
  end
  let!(:new_comment_notification_with_single_attachment) do
    create :system_notification, :new_comment,
           notifiable: create(:comment, event: event, attachments: [create(:attachment)]),
           profile: profile
  end
  let!(:new_comment_notification_with_multiple_attachments) do
    create :system_notification, :new_comment,
           notifiable: create(:comment, event: event, attachments: create_list(:attachment, 2)),
           profile: profile
  end
  let!(:event_published_notification) do
    create :system_notification, :event_published,
           notifiable: event,
           profile: profile
  end
  let!(:event_canceled_notification) do
    create :system_notification, :event_canceled,
           notifiable: event,
           profile: profile
  end
  let!(:new_comment_notification) do
    create :system_notification, :new_comment,
           notifiable: comment,
           profile: profile,
           author: comment.profile
  end
  let!(:blocked_notification) do
    create :system_notification, :blocked,
           notifiable: blocked_course,
           profile: profile
  end
  let!(:new_member_notification) do
    create :system_notification, :new_member,
           notifiable: course_as_teacher,
           profile: profile,
           author: new_student
  end

  before do
    profile.block_in!(blocked_course)
  end

  before do
    notifications = [
      new_comment_notification_from_blocked_course,
      new_comment_notification_with_single_attachment,
      new_comment_notification_with_multiple_attachments,
      event_published_notification,
      event_canceled_notification,
      new_comment_notification,
      blocked_notification,
      new_member_notification
    ]

    # For some reason the array is coming reversed from ActiveRecord::find
    expect(BuildDigest).to receive(:new).with(
      profile,
      match_array(notifications)
    ).and_call_original
    DigestMailer.digest(profile.id, notifications.map(&:id)).deliver
  end

  after do
    ActionMailer::Base.deliveries.clear
  end

  it { expect(ActionMailer::Base.deliveries.count).to eq 1 }

  let(:email) { ActionMailer::Base.deliveries.first }

  it { expect(email.to).to eq [profile.email] }
  it do
    expect(email.subject).to eq "\xE2\x98\x95 Café da manhã com Dunno"
  end
  it { expect(email.from).to eq ['contato@dunnoapp.com'] }
  it { expect(email.body).to include course_as_student.name }
  it { expect(email.body).to include teacher.name }

  it { expect(email.body).to include 'Quinta, 01/Jan - 14:00' }
  it { expect(email.body).to include 'Aula publicada' }
  it { expect(email.body).to include topic.description }
  it { expect(email.body).not_to include personal_topic.description }

  it { expect(email.body).to include comment.body }
  it { expect(email.body).to include comment.profile.name }
  it { expect(email.body).to include comment.profile.avatar_url }
  it { expect(email.body).to include "(1 anexo)" }
  it { expect(email.body).to include "(2 anexos)" }

  it { expect(email.body).to include blocked_course.name }
  it { expect(email.body).to include 'Você foi bloqueado desta disciplina.' }
  it { expect(email.body).not_to include comment_from_blocked_course.body }

  it { expect(email.body).to include course_as_teacher.name }
  it { expect(email.body).to include "Novos estudantes:" }
  it { expect(email.body).to include new_student.name }
end
