commentList = ($location) ->
  commentListCtrl = ->
    vm = this
    vm.addComment = (comment) ->
      vm.event.comments.push(comment)
      vm.event.comments_count = vm.event.comments.length

    vm.commentSelected = (comment) ->
      parseInt($location.search().commentId) == comment.id

    vm

  templateUrl: 'courses/events/comment-list.directive'
  restrict: 'E'
  scope:
    event: '='
  controller: commentListCtrl
  controllerAs: 'vm'
  bindToController: true

commentList.$inject = ['$location']

angular
  .module('app.courses')
  .directive('commentList', commentList)
