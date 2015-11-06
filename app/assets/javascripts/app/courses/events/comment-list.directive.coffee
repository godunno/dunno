commentList = ($location) ->
  commentListCtrl = ($scope, SessionManager) ->
    vm = this
    $scope.course = vm.course

    vm.addComment = (comment) ->
      vm.event.comments.push(comment)
      vm.event.comments_count = vm.event.comments.length

    vm.commentSelected = (comment) ->
      parseInt($location.search().commentId) == comment.id

    vm.canRemoveComment = (comment) ->
      !comment.removed_at && comment.user.id == SessionManager.currentUser().id

    # Need to unset the loading property to avoid conflicts with the object's serialization
    unsetLoading = (comment) -> comment._loading = undefined

    vm.removeComment = (comment) ->
      message = """
        Tem certeza de que deseja remover este comentário?
        Esta operação não poderá ser desfeita.
      """
      comment._loading = comment.remove().then(unsetLoading) if confirm(message)

    vm.canBlockComment = (comment) -> !comment.blocked_at

    vm.blockComment = (comment) ->
      message = 'Tem certeza de que deseja bloquear este comentário?'
      comment._loading = comment.block().then(unsetLoading) if confirm(message)

    vm.unblockComment = (comment) ->
      comment._loading = comment.unblock().then(unsetLoading)

    vm.canShowBody = (comment) ->
      !comment.removed_at && !(comment.blocked_at && !comment._showBody)

    vm.isRemoved = (comment) -> !!comment.removed_at
    vm.isBlocked = (comment) -> !!comment.blocked_at

    vm.showBlockedBody = (comment) -> comment._showBody = true
    vm.hideBlockedBody = (comment) -> comment._showBody = false

    vm

  commentListCtrl.$inject = ['$scope', 'SessionManager']

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
