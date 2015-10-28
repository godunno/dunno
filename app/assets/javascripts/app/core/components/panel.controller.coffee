PanelCtrl = ($previousState) ->
  vm = this
  $previousState.memo("panelInvoker")
  vm.close = ->
    $previousState.go("panelInvoker")
  vm

PanelCtrl.$inject = ['$previousState']

angular
  .module('app.core')
  .controller('PanelCtrl', PanelCtrl)
