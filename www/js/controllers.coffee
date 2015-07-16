angular.module 'perkkx.controllers', []
.controller 'LoginCtrl', ($scope, $state, pxUserCred, $log, $cordovaToast) ->
  $scope.data =
    username: ''
    password: ''
    error: ""

  $scope.state =
    isLoading: true
    loginPage: false
    error: false

  pxUserCred.confirmCreds (res) ->
    $log.info "got result for confirmation as : #{res}"
    $scope.state.isLoading = false

    if not res
      $scope.state.loginPage = true
    else
      $state.go('tab.redeem')

  $scope.submit = () ->
    $scope.state.isLoading = true
    $scope.state.error = false
    pxUserCred.login $scope.data.username, $scope.data.password, (res) ->
      $scope.state.isLoading = false
      if not res
        $scope.state.error = true
        $scope.state.loginPage = true
        $scope.data.error = "Login failed"
      else
        $scope.data.username = ''
        $scope.data.password = ''
        $state.go('tab.redeem')
        $cordovaToast.show "Login success", "short", "bottom"

.controller 'ChangePassCtrl', ($scope, $state, pxUserCred, $log, $cordovaToast) ->
  $scope.data =
    username: ''
    password_old: ''
    password_new: ''
    password_new_rep: ''
    error: ''

  clear = () ->
    $scope.data.password_old = ''
    $scope.data.password_new = ''
    $scope.data.password_new_rep = ''


  $scope.state =
    error: false
    isLoading: false

  pxUserCred.register (id, vname, username) ->
    $scope.data.username = username

  validate = () ->
    $scope.data.username != '' and $scope.data.password_old != '' and
      $scope.data.password_new != '' and $scope.data.password_new == $scope.data.password_new_rep

  $scope.cancel = () ->
    clear()
    $state.go('tab.redeem')

  $scope.submit = () ->
    $scope.state.isLoading = true
    $scope.state.error = false
    if validate()
      pxUserCred.change_pass $scope.data.username, $scope.data.password_old, $scope.data.password_new, (res) ->
        $scope.state.isLoading = false
        if not res
          $scope.state.error = true
          $scope.data.error = "Password change failed"
        else
          $scope.state.error = false
          clear()
          $state.go('login')
          $cordovaToast.show "Password changed successfully, please login", "long", "bottom"
    else
      $scope.state.isLoading = false
      $scope.state.error = true
      $scope.data.error = "the passwords do not match"
      $log.debug "change pass: #{JSON.stringify($scope.data)}"


.controller 'MainCtrl', ($scope, $rootScope, $state, pxUserCred, pxBadgeProvider, $log, $ionicSideMenuDelegate) ->

  # --- Private --------------- #
  $scope.badges =
    used: 0
    disputed: 0

  $scope.state =
    sideBar: false

  callback = (obj) ->
    $scope.setBadge k, v for own k, v of obj
  # --------------------------- #

  # ------- Methods ----------- #
  $scope.setBadge = (key, num) ->
    $scope.badges[key] = num

  $scope.menu = () ->
    $ionicSideMenuDelegate.toggleLeft()

  # --------- Setup ----------- #
  pxBadgeProvider.setUpdater callback

  # --------- State checking -- #
  $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
    $log.info "Changing state from #{fromState.name} to #{toState.name}"
    if toState.name == 'login' || toState.name == 'change_pass'
      $scope.state.sideBar = false
    else
      $scope.state.sideBar = true


.controller 'SideBarCtrl', ($scope, pxUserCred, $state, $ionicSideMenuDelegate)->

  $scope.state =
    registered: false

  $scope.data =
    title: "Perkkx"
    vendor_id: ''
    vendor_name: ''

  pxUserCred.register (id, name, username) ->
    $scope.data.vendor_id = id
    $scope.data.vendor_name = name
    $scope.data.username = username
    $scope.state.registered = true


  $scope.logout = () ->
    $scope.state.registered = false
    $ionicSideMenuDelegate.toggleLeft(false)
    pxUserCred.logout()
    $state.go('login')

  $scope.change_pass = () ->
    $ionicSideMenuDelegate.toggleLeft(false)
    $state.go('change_pass')


.controller 'RedeemCtrl', ($log, $scope, pxApiConnect, pxBadgeProvider) ->
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
