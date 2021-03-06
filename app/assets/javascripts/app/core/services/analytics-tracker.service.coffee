AnalyticsTracker = ($analytics) ->
  trackEventStatus = (event, previousStatus) ->
    message = switch event.status
      when 'published' then 'Event Published'
      when 'canceled' then 'Event Canceled'
      when 'draft' then 'Event Set Back To Draft'

    $analytics.eventTrack message,
      merge eventAttrs(event), previousStatus: previousStatus

  topicCreated = (topic, topicType) ->
    $analytics.eventTrack 'Content Added',
      private: topic.personal
      eventUuid: topic.event.uuid
      type: topicType

  courseAccessed = (course, page) ->
    $analytics.eventTrack 'Course Accessed',
      merge courseAttrs(course), page: page

  eventAccessed = (event, page) ->
    $analytics.eventTrack 'Event Accessed',
      merge eventAttrs(event), page: page

  eventCanceledAccessed = (event) ->
    $analytics.eventTrack 'Event Canceled Accessed',
      eventAttrs(event)

  courseCreated = (course) ->
    $analytics.eventTrack 'Course Created',
      courseAttrs(course)

  courseEdited = (course) ->
    $analytics.eventTrack 'Course Edited',
      courseAttrs(course)

  courseJoined = (course) ->
    $analytics.eventTrack 'Course Joined',
      courseAttrs(course)

  courseCloneConfirmationAccessed = (course) ->
    $analytics.eventTrack 'Course Clone Confirmation Accessed',
      courseAttrs(course)

  courseCloneConfirmed = (course) ->
    $analytics.eventTrack 'Course Clone Confirmed',
      courseAttrs(course)

  cloneCourseLinkCreated = (course) ->
    $analytics.eventTrack 'Clone Course Link Created',
      courseAttrs(course)

  scheduleCreated = (weeklySchedule) ->
    $analytics.eventTrack 'Schedule Created',
      weeklyScheduleAttrs(weeklySchedule)

  scheduleEdited = (weeklySchedule) ->
    $analytics.eventTrack 'Schedule Edited',
      weeklyScheduleAttrs(weeklySchedule)

  scheduleRemoved = (weeklySchedule) ->
    $analytics.eventTrack 'Schedule Removed',
      weeklyScheduleAttrs(weeklySchedule)

  commentCreated = (comment) ->
    $analytics.eventTrack 'Comment Created',
      commentAttrs(comment)

  systemNotificationsAccessed = ->
    $analytics.eventTrack 'Notifications Accessed'

  systemNotificationClicked = (systemNotification) ->
    $analytics.eventTrack 'Notification Clicked',
      systemNotificationAttrs(systemNotification)

  courseAttrs = (course) ->
    uuid: course.uuid
    name: course.name
    className: course.class_name
    institution: course.institution
    startDate: formatDate(course.start_date)
    endDate: formatDate(course.end_date)
    userRole: course.user_role
    teacherName: course.teacher.name
    active: course.active

  eventAttrs = (event) ->
    courseUuid: event.course.uuid
    courseName: event.course.name
    status: event.status
    startAt: event.start_at

  weeklyScheduleAttrs = (weeklySchedule) ->
    uuid: weeklySchedule.uuid
    classroom: weeklySchedule.classroom
    startTime: weeklySchedule.start_time
    endTime: weeklySchedule.end_time
    weekday: weeklySchedule.weekday

  commentAttrs = (comment) ->
    id: comment.id
    userId: comment.user.id
    userName: comment.user.name
    attachmentsCount: comment.attachments.length

  systemNotificationAttrs = (systemNotification) ->
    notificationType: systemNotification.notification_type
    authorName: systemNotification.author.name

  merge = ->
    angular.extend({}, arguments...)

  formatDate = (date) ->
    (null || date && moment(date).format('YYYY-MM-DD'))

  trackEventStatus: trackEventStatus
  topicCreated: topicCreated
  courseAccessed: courseAccessed
  courseCreated: courseCreated
  courseEdited: courseEdited
  courseJoined: courseJoined
  courseCloneConfirmationAccessed: courseCloneConfirmationAccessed
  courseCloneConfirmed: courseCloneConfirmed
  cloneCourseLinkCreated: cloneCourseLinkCreated
  eventAccessed: eventAccessed
  eventCanceledAccessed: eventCanceledAccessed
  scheduleCreated: scheduleCreated
  scheduleEdited: scheduleEdited
  scheduleRemoved: scheduleRemoved
  commentCreated: commentCreated
  systemNotificationsAccessed: systemNotificationsAccessed
  systemNotificationClicked: systemNotificationClicked

AnalyticsTracker.$inject = ['$analytics']

angular
  .module('app.core')
  .factory('AnalyticsTracker', AnalyticsTracker)
