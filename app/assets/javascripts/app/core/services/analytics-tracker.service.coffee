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

  courseAttrs = (course) ->
    uuid: course.uuid
    name: course.name
    className: course.class_name
    institution: course.institution
    startDate: formatDate(course.start_date)
    endDate: formatDate(course.end_date)
    userRole: course.user_role
    teacherName: course.teacher.name

  eventAttrs = (event) ->
    courseUuid: event.course.uuid
    courseName: event.course.name
    status: event.status
    startAt: event.start_at

  merge = ->
    angular.extend({}, arguments...)


  formatDate = (date) ->
    (null || date && moment(date).format('YYYY-MM-DD'))

  trackEventStatus: trackEventStatus
  topicCreated: topicCreated
  courseAccessed: courseAccessed
  courseCreated: courseCreated
  courseEdited: courseEdited
  eventAccessed: eventAccessed
angular
  .module('app.core')
  .factory('AnalyticsTracker', AnalyticsTracker)

