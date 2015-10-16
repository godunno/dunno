commentForm = (
  $q,
  SessionManager,
  UserComment,
  FoundationApi,
  AnalyticsTracker
) ->
  commentFormCtrl = ->
    @user = SessionManager.currentUser()
    @comment = new UserComment(event_start_at: @event.start_at)

    @send = =>
      return if @commentForm.$invalid
      @submitting = $q.all(@filePromises).then =>
        @comment.save().then (comment) =>
          @onSave()(comment)
          AnalyticsTracker.commentCreated(comment)
        .then =>
          @comment = new UserComment
            event_start_at: @event.start_at
            attachment_ids: []
          @filePromises = []

    @

  templateUrl: 'courses/events/comment-form.directive'
  restrict: 'E'
  scope:
    onSave: '&'
    event: '='
  controller: commentFormCtrl
  controllerAs: 'vm'
  bindToController: true

commentForm.$inject = [
  '$q',
  'SessionManager',
  'UserComment',
  'FoundationApi',
  'AnalyticsTracker'
]

angular
  .module('app.courses')
  .directive('commentForm', commentForm)
