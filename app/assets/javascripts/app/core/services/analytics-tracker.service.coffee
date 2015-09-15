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

  courseCreated = (course) ->
    $analytics.eventTrack 'Course Created',
      courseAttrs(course)

  courseEdited = (course) ->
    $analytics.eventTrack 'Course Edited',
      courseAttrs(course)

  courseJoined = (course) ->
    $analytics.eventTrack 'Course Joined',
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
  eventAccessed: eventAccessed
  scheduleCreated: scheduleCreated
  scheduleEdited: scheduleEdited
  scheduleRemoved: scheduleRemoved
angular
  .module('app.core')
  .factory('AnalyticsTracker', AnalyticsTracker)

