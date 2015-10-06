commentList = ->
  commentListCtrl = ->
    vm = this
    vm.addComment = (comment) ->
      vm.event.comments.push(comment)

    vm

  templateUrl: 'courses/events/comment-list.directive'
  restrict: 'E'
  scope:
    event: '='
  controller: commentListCtrl
  controllerAs: 'vm'
  bindToController: true

#commentList.$inject = ['SessionManager', 'UserComment', 'FoundationApi']
angular
  .module('app.courses')
  .directive('commentList', commentList)
