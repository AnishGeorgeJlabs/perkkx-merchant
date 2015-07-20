angular.module 'perkkx.controllers.credentials', []
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
    if res
      $state.go('tab.redeem')
    $scope.state.loginPage = true

  $scope.submit = () ->
    $scope.state.isLoading = true
    $scope.state.error = false
    pxUserCred.login $scope.data.username, $scope.data.password, (res) ->
      $scope.state.isLoading = false
      if not res
        $scope.state.error = true
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

  pxUserCred.register (d) ->
    $scope.data.username = d.username

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
