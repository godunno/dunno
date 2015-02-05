DunnoApp = angular.module('DunnoApp')

CoursesIndexCtrl = ($scope, $routeParams, Course, SessionManager, AssetsPreloader)->
  $scope.$emit('wholePageLoading', Course.query().then (courses)->
    $scope.courses = courses
  )

  if !SessionManager.currentUser().completed_tutorial
    tutorials = {1: [1], 2: [1,2], 3: [1,2,3]}
    for tutorial, steps of tutorials
      for step in steps
        image = "/assets/tutorial/tutorial-arrow-#{tutorial}-#{step}.png"
        AssetsPreloader.loadImage(image)
    AssetsPreloader.loadFont('Chalkduster')
CoursesIndexCtrl.$inject = ['$scope', '$routeParams', 'Course', 'SessionManager', 'AssetsPreloader']
DunnoApp.controller 'CoursesIndexCtrl', CoursesIndexCtrl
