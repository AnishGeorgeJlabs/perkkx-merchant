angular.module 'perkkx.controllers', []
.controller 'BadgeCtrl', ($scope) ->
  console.log "initialized BadgeCtrl"
  $scope.badges =
    pending: 0
    used: 0
    expired: 0
    disputed: 0

  $scope.updateBadge = (key, num) ->
    if $scope.badges.hasOwnProperty(key) && num >= 0
      $scope.badges[key] = num

.controller 'AuxCtrl', ($scope, $log) ->
  $scope.code = ""
  $scope.clearCode = () -> $scope.code = ""

.controller 'PendingCtrl', ($log, $scope, pxApiConnect) ->
  $scope.rcode = ""
  $scope.clearRcode = (rcode) -> rcode = ""
  $scope.resultCode = {}

  $scope.load = false
  $scope.result = false
  $scope.error = false
  $scope.billshow = false

  $scope.toggleBill = () ->
    $scope.billshow = !$scope.billshow

  $scope.get = (code) ->
    $log.debug "rcode : #{code}"
    if code.length == 8
      $log.debug "yeahh"
      $scope.load = true
      pxApiConnect.apiCheckValid(code, $scope.callback)
    else
      $scope.result = false
      $scope.error = false
      $scope.billshow = false
      $log.debug "else part, #{$scope.billshow}"

  $scope.callback = (data) ->
    $scope.load = false
    $log.debug "data : #{JSON.stringify(data)}"
    if data.valid
      $scope.resultCode = data.data
      $scope.result = true
    else
      $log.debug "else part"
      $scope.error = true


  $scope.submit = (data) ->
    $scope.load = true
    pxApiConnect.apiSubmit(data)
    .finally () ->
      $scope.billshow = false
      $scope.error = false
      $scope.result = false
      $scope.load = false

  ###
  $scope.load = () ->
    $ionicLoading.show(
      template: "Loading..."
      hideOnStateChange: true
    )
  ###

  ###
  $scope.codes = []
  pxApiConnect.setCallBack 'pending', (data, more) ->
    if more
      $scope.codes.push obj for obj in data
    else $scope.codes = data

  $scope.initGet = () -> pxApiConnect.apiGet 'pending'

  $scope.initGet()

  $scope.refresh = () ->
    $scope.initGet()
    .finally () ->
      $scope.$broadcast('scroll.refreshComplete')

  $scope.loadMore = () ->
    res = pxApiConnect.apiMore 'pending'
    if res.more
      res.future.finally () -> $scope.$broadcast('scroll.infiniteScrollComplete')
    else
      $scope.$broadcast('scroll.infiniteScrollComplete')

  $scope.submit = (data) ->
    pxApiConnect.apiSubmit(data)
    .finally () -> $scope.initGet()
  ###


.controller 'UsedCtrl', ($scope, pxApiConnect) ->
  $scope.codes = []
  pxApiConnect.setCallBack 'used', (data, more) ->
    if more
      $scope.codes.push obj for obj in data
    else $scope.codes = data

  $scope.initGet = () -> pxApiConnect.apiGet 'used'

  $scope.initGet()

  $scope.refresh = () ->
    $scope.initGet()
    .finally () ->
      $scope.$broadcast('scroll.refreshComplete')

  $scope.loadMore = () ->
    res = pxApiConnect.apiMore 'used'
    if res.more
      res.future.finally () -> $scope.$broadcast('scroll.infiniteScrollComplete')
    else
      $scope.$broadcast('scroll.infiniteScrollComplete')

  $scope.submit = (data) ->
    pxApiConnect.apiSubmit(data)
    .finally () -> $scope.initGet()

.controller 'ExpiredCtrl', ($scope, pxApiConnect) ->
  $scope.codes = []
  pxApiConnect.setCallBack 'expired', (data, more) ->
    if more
      $scope.codes.push obj for obj in data
    else $scope.codes = data

  $scope.initGet = () -> pxApiConnect.apiGet 'expired'

  $scope.initGet()

  $scope.refresh = () ->
    $scope.initGet()
    .finally () ->
      $scope.$broadcast('scroll.refreshComplete')

  $scope.loadMore = () ->
    res = pxApiConnect.apiMore 'expired'
    if res.more
      res.future.finally () -> $scope.$broadcast('scroll.infiniteScrollComplete')
    else
      $scope.$broadcast('scroll.infiniteScrollComplete')

  $scope.submit = (data) ->
    pxApiConnect.apiSubmit(data)
    .finally () -> $scope.initGet()

.controller 'DisputeCtrl', ($scope, pxApiConnect) ->
  $scope.codes = []
  pxApiConnect.setCallBack 'disputed', (data, more) ->
    if more
      $scope.codes.push obj for obj in data
    else $scope.codes = data

  $scope.initGet = () -> pxApiConnect.apiGet 'disputed'

  $scope.initGet()

  $scope.refresh = () ->
    $scope.initGet()
    .finally () ->
      $scope.$broadcast('scroll.refreshComplete')

  $scope.loadMore = () ->
    res = pxApiConnect.apiMore 'disputed'
    if res.more
      res.future.finally () -> $scope.$broadcast('scroll.infiniteScrollComplete')
    else
      $scope.$broadcast('scroll.infiniteScrollComplete')

  $scope.submit = (data) ->
    pxApiConnect.apiSubmit(data)
    .finally () -> $scope.initGet()


.controller 'TestCtrl', ($scope) ->
  console.log "Initialised Test"
###
.controller 'PendingCtrl', ($scope, pxApiConnect) ->
  $scope.pcodes = []
  $scope.submit = (obj) ->
.controller 'UsedCtrl', ($scope, pxApiConnect) ->
  $scope.ucodes = []
  $scope.submit = (obj) ->
.controller 'ExpiredCtrl', ($scope, pxApiConnect) ->
  $scope.ecodes = []
  $scope.submit = (obj) ->
.controller 'DisputeCtrl', ($scope, pxApiConnect) ->
  $scope.dcodes = []
  $scope.submit = (obj) ->
###
###
.controller 'TabCtrl', ($scope, pxApiConnect) ->
  $scope.data = []

  $scope.setCallBack = (key) ->
    pxApiConnect.setCallBack key, (data, more) ->
      if more
        $scope.data.push obj for obj in data
      else $scope.data = data

  $scope.initGet = (key) -> pxApiConnect.getApi key
  $scope.refresh = (key) ->
    $scope.initGet key
    .finally () ->
      $scope.$broadcast 'scroll.refreshComplete'
  $scope.loadMore = (key) ->
    $scope.initGet key
    .finally () ->
      $scope.$broadcast 'scroll.infiniteScrollComplete'
  $scope.submit = (obj) -> pxApiConnect.apiSubmit(obj)
###

