// Generated by CoffeeScript 1.9.3
(function() {
  var hasProp = {}.hasOwnProperty;

  angular.module('perkkx.controllers.main', []).controller('MainCtrl', function($scope, $rootScope, $state, $log, $ionicSideMenuDelegate, $ionicPlatform, $ionicPopup, pxUserCred, pxBadgeProvider) {

    /*
      Parent for the view controllers. manages the badges and all for the tabs
     */
    var callback;
    $scope.badges = {
      used: 0,
      disputed: 0
    };
    $scope.state = {
      sideBar: false
    };
    callback = function(obj) {
      var k, results, v;
      results = [];
      for (k in obj) {
        if (!hasProp.call(obj, k)) continue;
        v = obj[k];
        results.push($scope.setBadge(k, v));
      }
      return results;
    };
    $scope.setBadge = function(key, num) {
      return $scope.badges[key] = num;
    };
    $scope.menu = function() {
      return $ionicSideMenuDelegate.toggleLeft();
    };
    $scope.navBarCheck = function() {
      return !($state.is('login') || $state.is('change_pass'));
    };
    pxBadgeProvider.setUpdater(callback);
    $rootScope.$on('$stateChangeStart', function(event, toState, toParams, fromState, fromParams) {
      if (toState.name === 'login' || toState.name === 'change_pass') {
        return $scope.state.sideBar = false;
      } else {
        return $scope.state.sideBar = true;
      }
    });
    return $ionicPlatform.registerBackButtonAction(function() {
      if ($state.is('tab.redeem') || $state.is('login')) {
        return $ionicPopup.confirm({
          title: "Exit App",
          content: "Are you sure you want to exit Perkkx?",
          okType: 'button-clear button-small button-assertive',
          okText: 'Exit',
          cancelType: 'button-clear button-small'
        }).then(function(result) {
          if (result) {
            return navigator.app.exitApp();
          }
        });
      } else {
        return $state.go('tab.redeem');
      }
    }, 120);
  }).controller('SideBarCtrl', function($scope, pxUserCred, $state, $ionicSideMenuDelegate) {

    /*
      Controller for the sidebar
     */
    $scope.data = {
      title: "Perkkx"
    };
    pxUserCred.register(function(d) {
      $scope.data.vendor_id = d.vendor_id;
      $scope.data.vendor_name = d.vendor_name;
      $scope.data.username = d.username;
      return $scope.data.address = d.address;
    });
    $scope.logout = function() {
      $ionicSideMenuDelegate.toggleLeft(false);
      pxUserCred.logout();
      return $state.go('login');
    };
    return $scope.change_pass = function() {
      $ionicSideMenuDelegate.toggleLeft(false);
      return $state.go('change_pass');
    };
  });

}).call(this);
