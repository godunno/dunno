# Adapted from: https://docs.angularjs.org/api/ng/type/ngModel.NgModelController
DunnoApp = angular.module("DunnoApp")

contenteditable = ($sce) ->
  restrict: 'A', # only activate on element attribute
  require: '?ngModel', # get a hold of NgModelController
  link: (scope, element, attrs, ngModel)->
    return if (!ngModel) # do nothing if no ng-model

    # Specify how UI should be updated
    ngModel.$render = ->
      element.html($sce.getTrustedHtml(ngModel.$viewValue || ''))

    # Listen for change events to enable binding
    element.on('blur keyup change', ->
      scope.$evalAsync(read)
    )

    # Write data to the model
    read = ->
      ngModel.$setViewValue(element.text())

contenteditable.$inject = ["$sce"]
DunnoApp.directive "contenteditable", contenteditable
