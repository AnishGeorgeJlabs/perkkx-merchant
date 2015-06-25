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
  pxApiConnect.setCallBack 'pending', (data, more) ->
    if more
      $scope.pcodes.push obj for obj in data
    else $scope.pcodes = data

  pxApiConnect.apiGet 'pending'
  $scope.refresh = () ->
    pxApiConnect.apiGet 'pending'
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
    pxApiConnect.apiGet 'pending'


.controller 'UsedCtrl', ($scope, pxApiConnect) ->
  $scope.ucodes = []
  pxApiConnect.setCallBack 'used', (data, more) ->
    if more
      $scope.ucodes.push obj for obj in data
    else $scope.ucodes = data

  pxApiConnect.apiGet 'used'
  $scope.refresh = () ->
    pxApiConnect.apiGet 'used'
    .finally () ->
      $scope.$broadcast('scroll.refreshComplete')
  $scope.loadMore = () ->
    res = pxApiConnect.apiMore 'used'
    if res.more
      res.future.finally () -> $scope.$broadcast('scroll.infiniteScrollComplete')
    else
      $scope.$broadcast('scroll.infiniteScrollComplete')
  $scope.submit = (data) -> console.log "Data: #{data}"

.controller 'ExpiredCtrl', ($scope, pxApiConnect) ->
  $scope.ecodes = []
  pxApiConnect.setCallBack 'expired', (data, more) ->
    if more
      $scope.ecodes.push obj for obj in data
    else $scope.ecodes = data

  pxApiConnect.apiGet 'expired'
  $scope.refresh = () ->
    pxApiConnect.apiGet 'expired'
    .finally () ->
      $scope.$broadcast('scroll.refreshComplete')
  $scope.loadMore = () ->
    res = pxApiConnect.apiMore 'expired'
    if res.more
      res.future.finally () -> $scope.$broadcast('scroll.infiniteScrollComplete')
    else
      $scope.$broadcast('scroll.infiniteScrollComplete')
  $scope.submit = (data) -> console.log "Data: #{data}"

.controller 'DisputeCtrl', ($scope, pxApiConnect) ->
  $scope.dcodes = []
  pxApiConnect.setCallBack 'disputed', (data, more) ->
    if more
      $scope.dcodes.push obj for obj in data
    else $scope.dcodes = data

  pxApiConnect.apiGet 'disputed'
  $scope.refresh = () ->
    pxApiConnect.apiGet 'disputed'
    .finally () ->
      $scope.$broadcast('scroll.refreshComplete')
  $scope.loadMore = () ->
    res = pxApiConnect.apiMore 'disputed'
    if res.more
      res.future.finally () -> $scope.$broadcast('scroll.infiniteScrollComplete')
    else
      $scope.$broadcast('scroll.infiniteScrollComplete')
  $scope.submit = (data) -> console.log "Data: #{data}"

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
