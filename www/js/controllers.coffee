angular.module 'perkkx.controllers', []
.controller 'BadgeCtrl', ($scope, pxBadgeProvider, $log) ->
  $log.info "initialized BadgeCtrl"

  # --- Private --------------- #
  $scope.badges =
    used: 0
    disputed: 0

  updateBadge = (key, newNum) ->
    $scope.badges[key] = newNum - $scope.badges[key]

  callback = (obj) ->
    updateBadge k, v for own k, v of obj
  # --------------------------- #

  # ----Watched by children---- #
  $scope.refreshUsed = false
  $scope.refreshDisputed = false
  # --------------------------- #

  $scope.setBadge = (key, num) ->
    $scope.badges[key] = num

  $scope.updateAll = () ->
    pxBadgeProvider.update().success (data) ->
      callback(data)

  $scope.updateAll()




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
    $log.debug "submitting data: #{data}"
    pxApiConnect.apiSubmit(data)
    .finally () ->
      $scope.clearInput()   # also clears state
      $scope.$parent.updateAll()
      $scope.$parent.refreshUsed = true


  # -------- Watchers ------------- #
  # JUST to get the input size limit working
  $scope.$watch(
    () -> $scope.data.rcode
    (old_val, new_val) -> $scope.data.rcode == old_val if new_val.length > 8
  )


.controller 'UsedCtrl', ($scope, pxApiConnect, $log) ->
  $scope.codes = []
  pxApiConnect.setCallBack 'used', (data, more) ->
    if more
      $scope.codes.push obj for obj in data
    else $scope.codes = data

  $scope.initGet = () ->
    $log.debug "Init get for used called"
    pxApiConnect.apiGet 'used'

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

  # ---- Watchers -------- #
  $scope.$watch(
    () -> $scope.$parent.refreshUsed
    (oldVal, newVal) ->
      $scope.initGet() if newVal
      $scope.$parent.refreshUsed = true
      $scope.$parent.refreshDisputed = true
  )

.controller 'DisputeCtrl', ($log, $scope, pxApiConnect) ->
  $log.debug "Initialised Dispute ctrl"
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

  # ---- Watchers -------- #
  $scope.$watch(
    () -> $scope.$parent.refreshDisputed
    (oldVal, newVal) ->
      $scope.initGet() if newVal
      $scope.$parent.refreshDisputed = false
  )


.controller 'TestCtrl', ($scope) ->
  console.log "Initialised Test"
  $scope.data = {
    code: ""
  }
  $scope.hello = () -> alert $scope.data.code
  $scope.clear = () -> $scope.data.code = ""
###
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
###
