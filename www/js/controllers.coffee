angular.module 'perkkx.controllers', []
.controller 'BadgeCtrl', ($scope, pxBadgeProvider, $log) ->
  $log.info "initialized BadgeCtrl"
  pxBadgeProvider.setUpdater($scope.updateAll)

  # --- Private --------------- #
  $scope.badges =
    used: 0
    disputed: 0


  callback = (obj) ->
    $scope.setBadge k, v for own k, v of obj
  # --------------------------- #

  # # ----Watched by children---- #
  # $scope.refreshUsed = false
  # $scope.refreshDisputed = false
  # # --------------------------- #

  $scope.setBadge = (key, num) ->
    $scope.badges[key] = num

  pxBadgeProvider.setUpdater () ->
    $log.debug "update AALL"
    pxBadgeProvider.update().success (data) ->
      callback(data)

  pxBadgeProvider.refresh()



.controller 'PendingCtrl', ($log, $scope, pxApiConnect, pxBadgeProvider) ->
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
      #$scope.$parent.updateAll()
      pxBadgeProvider.refresh()
      #$scope.$parent.refreshUsed = true
      #$scope.$parent.refreshDisputed = true


  # -------- Watchers ------------- #
  # JUST to get the input size limit working
  $scope.$watch(
    () -> $scope.data.rcode
    (new_val, old_val) ->
      $scope.data.rcode = old_val if new_val.length > 8
  )


.controller 'UsedCtrl', ($scope, pxApiConnect, $log, pxBadgeProvider) ->
  $scope.codes = []
  pxApiConnect.setCallBack 'used', (data, more) ->
    if more
      $scope.codes.push obj for obj in data
    else $scope.codes = data
  pxBadgeProvider.setCallBack 'used', () -> $scope.initGet()

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
    .finally () ->
      #$scope.$parent.updateAll()
      pxBadgeProvider.refresh()

  # # ---- Watchers -------- #
  # $scope.$watch(
  #   () -> $scope.$parent.refreshUsed
  #   (newVal, oldVal) ->
  #     $log.debug "refresh used checking"
  #     $scope.initGet() if newVal
  #     $scope.$parent.refreshUsed = true
  #     $scope.$parent.refreshDisputed = true
  # )

.controller 'DisputeCtrl', ($log, $scope, pxApiConnect, pxBadgeProvider) ->
  $log.debug "Initialised Dispute ctrl"
  $scope.codes = []
  pxApiConnect.setCallBack 'disputed', (data, more) ->
    if more
      $scope.codes.push obj for obj in data
    else $scope.codes = data

  pxBadgeProvider.setCallBack 'disputed', () ->
    $log.debug "pxBadge for disputed"
    $scope.initGet()

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
    .finally () ->
      #$scope.$parent.updateAll()
      pxBadgeProvider.refresh()


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
