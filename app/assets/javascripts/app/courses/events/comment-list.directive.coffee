commentList = ($location) ->
  commentListCtrl = (SessionManager) ->
    vm = this
    vm.addComment = (comment) ->
      vm.event.comments.push(comment)
      vm.event.comments_count = vm.event.comments.length

    vm.commentSelected = (comment) ->
      parseInt($location.search().commentId) == comment.id

    vm.canRemoveComment = (comment) ->
      !comment.removed_at && comment.user.id == SessionManager.currentUser().id

    vm.removeComment = (comment) ->
      message = """
      Tem certeza de que deseja remover este comentário? Esta operação não poderá ser desfeita.
      """
      comment._loading = comment.remove() if confirm(message)

    vm

  commentListCtrl.$inject = ['SessionManager']

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
