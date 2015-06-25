angular.module 'perkkx.controllers', []
.controller 'BadgeCtrl', ($scope) ->
  $scope.badges =
    pending: 0
    used: 0
    expired: 0
    disputed: 0

  $scope.updateBadge = (key, num) ->
    if $scope.badges.hasOwnProperty(key) && num >= 0
      $scope.badges[key] = num
.controller 'PendingCtrl', ($scope, pxApiConnect) ->
  $scope.pcodes = []
  pxApiConnect.setCallBack 'pending', (data) ->
    $scope.pcodes = data.data

  pxApiConnect.apiGet 'pending'
  $scope.submit = (obj) ->

.controller 'UsedCtrl', ($scope, pxApiConnect) ->
  $scope.ucodes = []
  pxApiConnect.setCallBack 'used', (data) ->
    $scope.ucodes = data.data

  pxApiConnect.apiGet 'used'

  $scope.submit = (obj) ->

.controller 'ExpiredCtrl', ($scope, pxApiConnect) ->
  $scope.ecodes = []
  pxApiConnect.setCallBack 'expired', (data) ->
    $scope.ecodes = data.data

  pxApiConnect.apiGet 'expired'

  $scope.submit = (obj) ->

.controller 'DisputeCtrl', ($scope, pxApiConnect) ->
  $scope.dcodes = []
  pxApiConnect.setCallBack 'disputed', (data) ->
    $scope.dcodes = data.data

  pxApiConnect.apiGet 'disputed'

  $scope.submit = (obj) ->

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
