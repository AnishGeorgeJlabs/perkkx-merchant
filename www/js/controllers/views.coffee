angular.module 'perkkx.controllers.views', []
.controller 'RedeemCtrl', ($log, $scope, pxApiConnect, pxBadgeProvider, pxUserCred) ->
  ###
    Controller for the first tab,
    used to search for the coupon and showing the deal
  ###
  # ---------- data ------------------------- #
  $scope.data =
    rcode: ""
    resultCode: ""

  $scope.state =
    isLoading: false
    isError: false
    haveResult: false
    billshow: false

  # ----------- private methods ------------- #
  clearState = () ->
    $scope.state.isLoading = false
    $scope.state.isError = false
    $scope.state.haveResult = false
    $scope.state.billshow = false

  callback = (data) ->
    $scope.state.isLoading = false
    $log.debug "data : #{JSON.stringify(data)}"
    if data.valid
      $scope.data.resultCode = data.data
      $scope.state.haveResult = true
      $scope.state.billshow = true
    else
      $log.debug "else part"
      $scope.state.isError = true
  # ----------------------------------------- #

  $scope.clearInput = () ->
    $log.debug 'clearing'
    clearState()
    $scope.data.rcode = ""

  $scope.checkCode = () ->
    rcode = $scope.data.rcode
    if rcode.length == 8
      $scope.state.isLoading = true
      pxApiConnect.apiCheckValid(rcode, callback)
    else
      clearState()

  $scope.submit = (data) ->
    $scope.state.isLoading = true
    $log.debug "submitting data: #{data}"
    pxApiConnect.apiSubmit(data)
    .finally () ->
      $scope.clearInput()   # also clears state
      pxBadgeProvider.refresh()

  pxUserCred.register () ->
    $scope.clearInput()

  # -------- Watchers ------------- #
  # JUST to get the input size limit working
  $scope.$watch(
    () -> $scope.data.rcode
    (new_val, old_val) ->
      $scope.data.rcode = old_val if new_val.length > 8
  )


.controller 'UsedCtrl', ($scope, pxApiConnect, $log, pxBadgeProvider, pxUserCred) ->
  ###
    Controller for tab 2,
    Shows the used codes
  ###
  # ------------ Data ------------------------------- #
  $scope.codes = []                                           # NOTE: not using 2-way binding

  # ------------ Methods ---------------------------- #
  $scope.initGet = () ->                                      # Basic GET operation
    $log.debug "Init get for used called"
    pxApiConnect.apiGet 'used'

  $scope.refresh = () ->                                      # For refreshing
    $scope.initGet()
    .finally () ->
      $scope.$broadcast('scroll.refreshComplete')

  $scope.loadMore = () ->                                     # For inifite scroll
    res = pxApiConnect.apiMore 'used'
    if res.more
      res.future.finally () -> $scope.$broadcast('scroll.infiniteScrollComplete')
    else
      $scope.$broadcast('scroll.infiniteScrollComplete')

  $scope.submit = (data) ->                                   # Data submission for bill
    pxApiConnect.apiSubmit(data)
    .finally () ->
      pxBadgeProvider.refresh()

  # ----------- Setup ------------------------------- #
  pxApiConnect.setCallBack 'used', (data, more) ->            # Setup the callback for GETing the data
    if more
      $scope.codes.push obj for obj in data
    else $scope.codes = data

  pxBadgeProvider.register () ->
    $scope.initGet()  # Setup callback for using badge provider, deprecated

  pxUserCred.register () ->
    $scope.initGet()                                          # All's done, so lets GET the data on initialisation



.controller 'PendingCtrl', ($log, $scope, pxApiConnect, pxBadgeProvider, pxUserCred) ->
  ###
    Last tab, used to show pending codes,
    NOTE: pending codes are actually disputed codes
  ###
  # ------------ Data ------------------------------- #
  $scope.codes = []

  # ------------ Methods --------------------------- #
  $scope.initGet = () -> pxApiConnect.apiGet 'disputed'

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
      pxBadgeProvider.refresh()

  # ------------ Setup ----------------------------- #
  pxApiConnect.setCallBack 'disputed', (data, more) ->
    if more
      $scope.codes.push obj for obj in data
    else $scope.codes = data

  pxBadgeProvider.register () ->
    $scope.initGet()

  pxUserCred.register () ->
    $scope.initGet()
