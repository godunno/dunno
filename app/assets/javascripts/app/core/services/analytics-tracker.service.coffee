AnalyticsTracker = ($analytics) ->
  trackEventStatus = (event, previousStatus) ->
    message = switch event.status
      when 'published' then 'Event Published'
      when 'canceled' then 'Event Canceled'
      when 'draft' then 'Event Set Back To Draft'

    $analytics.eventTrack message,
      courseUuid: event.course.uuid
      courseName: event.course.name
      previousStatus: previousStatus
      updatedStatus: event.status
      uuid: event.uuid
      startAt: event.start_at

  topicCreated = (topic, topicType) ->
    $analytics.eventTrack 'Content Added',
      private: topic.personal
      eventUuid: topic.event.uuid
      type: topicType

  courseAccessed = (course) ->

  courseCreated = (course) ->
    $analytics.eventTrack 'Course Created',
      uuid: course.uuid
      name: course.name
      className: course.class_name
      institution: course.institution
      startDate: formatDate(course.start_date)
      endDate: formatDate(course.end_date)

  courseEdited = (course) ->
    $analytics.eventTrack 'Course Edited',
      uuid: course.uuid
      name: course.name
      className: course.class_name
      institution: course.institution
      startDate: formatDate(course.start_date)
      endDate: formatDate(course.end_date)

  formatDate = (date) ->
    moment(date).format('YYYY-MM-DD')


  trackEventStatus: trackEventStatus
  topicCreated: topicCreated
  courseAccessed: courseAccessed
  courseCreated: courseCreated
  courseEdited: courseEdited
angular
  .module('app.core')
  .factory('AnalyticsTracker', AnalyticsTracker)

