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

.controller 'PendingCtrl', ($log, $scope, pxApiConnect, $ionicScrollDelegate) ->
  $scope.data =
    rcode: ""
    resultCode: ""

  $scope.state =
    isLoading: false
    isError: false
    haveResult: false
    billshow: false

  clearState = () ->
    $scope.state.isLoading = false
    $scope.state.isError = false
    $scope.state.haveResult = false
    $scope.state.billshow = false

  $scope.clearInput = () ->
    $log.debug 'clearing'
    clearState()
    $scope.data.rcode = ""

  $scope.checkCode = () ->
    rcode = $scope.data.rcode
    if rcode.length == 8
      $scope.state.isLoading = true
      pxApiConnect.apiCheckValid(rcode, $scope.callback)
    else
      clearState()


  $scope.callback = (data) ->
    $scope.state.isLoading = false
    $log.debug "data : #{JSON.stringify(data)}"
    if data.valid
      $scope.data.resultCode = data.data
      $scope.state.haveResult = true
    else
      $log.debug "else part"
      $scope.state.isError = true


  $scope.submit = (data) ->
    $scope.state.isLoading = true
    $ionicScrollDelegate.scrollTop()
    pxApiConnect.apiSubmit(data)
    .finally () ->
      clearState()


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
  $scope.data = {
    code: ""
  }
  $scope.hello = () -> alert $scope.data.code
  $scope.clear = () -> $scope.data.code = ""
