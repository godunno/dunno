commentForm = (SessionManager, UserComment, FoundationApi) ->
  commentFormCtrl = ->
    @user = SessionManager.currentUser()
    @comment = new UserComment(event_start_at: @event.start_at)

    @send = ->
      return if @commentForm.$invalid
      @submitting = @comment.save().then (comment) =>
        @onSave()(comment)
        FoundationApi.publish 'main-notifications',
          content: 'Comentário enviado, continue assim!'
      .then =>
        @comment = new UserComment(event_start_at: @event.start_at)

    @

  templateUrl: 'courses/events/comment-form.directive'
  restrict: 'E'
  scope:
    onSave: '&'
    event: '='
  controller: commentFormCtrl
  controllerAs: 'vm'
  bindToController: true

commentForm.$inject = ['SessionManager', 'UserComment', 'FoundationApi']

angular
  .module('app.courses')
  .directive('commentForm', commentForm)
