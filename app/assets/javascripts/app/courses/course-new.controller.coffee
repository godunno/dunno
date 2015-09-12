NewCourseCtrl = (modalInstance) ->

  @close = ->
    modalInstance.destroy()

  @

NewCourseCtrl.$inject = ['modalInstance']

angular
  .module('app.courses')
  .controller('NewCourseCtrl', NewCourseCtrl)
