commentList = ($location) ->
  commentListCtrl = ($scope, $sce, SessionManager, ngToast) ->
    vm = this
    $scope.course = vm.course

    vm.addComment = (comment) ->
      vm.event.comments.push(comment)
      vm.event.comments_count = vm.event.comments.length

    vm.commentSelected = (comment) ->
      parseInt($location.search().commentId) == comment.id

    vm.canRemoveComment = (comment) ->
      !comment.removed_at &&
      !comment.blocked_at &&
      comment.user.id == SessionManager.currentUser().id

    # Need to unset the loading property to avoid conflicts with the object's serialization
    unsetLoading = (comment) -> comment._loading = undefined

    vm.restoreComment = ->
      ngToast.dismiss(vm.restoreCommentToast)
      vm.removedComment._loading = vm.removedComment.restore().then(unsetLoading)

    vm.removeComment = (comment) ->
      comment._loading = comment.remove().then(unsetLoading).then ->
        vm.removedComment = comment
        vm.restoreCommentToast = ngToast.create
          dismissOnTimeout: false
          dismissOnClick: false
          dismissButton: true
          compileContent: $scope
          content: $sce.trustAsHtml("""
            <p>
              Comentário removido.
              <a ng-click="vm.restoreComment()">Desfazer</a>
            </p>
          """)

    vm.canBlockComment = (comment) ->
      !comment.removed_at &&
      !comment.blocked_at &&
      comment.user.id != SessionManager.currentUser().id

    vm.canUnblockComment = (comment) -> !!comment.blocked_at

    vm.blockComment = (comment) ->
      comment._loading = comment.block().then(unsetLoading)

    vm.unblockComment = (comment) ->
      comment._loading = comment.unblock().then(unsetLoading)

    vm.canShowBody = (comment) ->
      !comment.removed_at && !(comment.blocked_at && !comment._showBody)

    vm.isRemoved = (comment) -> !!comment.removed_at
    vm.isBlocked = (comment) -> !!comment.blocked_at

    vm.showBlockedBody = (comment) -> comment._showBody = true
    vm.hideBlockedBody = (comment) -> comment._showBody = false

    vm

  commentListCtrl.$inject = ['$scope', '$sce', 'SessionManager', 'ngToast']

  templateUrl: 'courses/events/comment-list.directive'
  restrict: 'E'
  scope:
    event: '='
    course: '='
  controller: commentListCtrl
  controllerAs: 'vm'
  bindToController: true

commentList.$inject = ['$location']

angular
  .module('app.courses')
  .directive('commentList', commentList)
