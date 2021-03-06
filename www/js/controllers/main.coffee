angular.module 'perkkx.controllers.main', []
.controller 'MainCtrl', ($scope, $rootScope, $state, $log,
                         $ionicSideMenuDelegate, $ionicPlatform, $ionicPopup
                         pxUserCred, pxBadgeProvider ) ->
  ###
    Parent for the view controllers. manages the badges and all for the tabs
  ###
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

  $scope.navBarCheck = () ->
    not($state.is('login') or $state.is('change_pass'))

  $scope.goTo = (substate) ->
    $state.go('tab.'+substate)

  # --------- Setup ----------- #
  pxBadgeProvider.setUpdater callback

  # --------- State checking -- #
  $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
    if toState.name == 'login' || toState.name == 'change_pass'
      $scope.state.sideBar = false
    else
      $scope.state.sideBar = true

  $ionicPlatform.registerBackButtonAction () ->
    if $state.is('tab.redeem') or $state.is('login')
      $ionicPopup.confirm
        title: "Exit App"
        content: "Are you sure you want to exit Perkkx?"
        okType: 'button-clear button-small button-assertive'
        okText: 'Exit'
        cancelType: 'button-clear button-small'
      .then (result) ->
        if result
          #$ionicPlatform.exitApp()
          navigator.app.exitApp()
    else
      $state.go 'tab.redeem'
  , 120

.controller 'SideBarCtrl', ($scope, pxUserCred, $state, $ionicSideMenuDelegate)->
  ###
    Controller for the sidebar
  ###
  $scope.data =
    title: "Perkkx"
  #  vendor_name: ''
  #  username: ''

  pxUserCred.register (d) ->
    $scope.data.vendor_id = d.vendor_id
    $scope.data.vendor_name = d.vendor_name
    $scope.data.username = d.username
    $scope.data.address = d.address      # Might not be there, undefined


  $scope.logout = () ->
    $ionicSideMenuDelegate.toggleLeft(false)
    pxUserCred.logout()
    $state.go('login')

  $scope.change_pass = () ->
    $ionicSideMenuDelegate.toggleLeft(false)
    $state.go('change_pass')
