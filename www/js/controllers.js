// Generated by CoffeeScript 1.9.3
(function() {
  var hasProp = {}.hasOwnProperty;

  angular.module('perkkx.controllers', []).controller('LoginCtrl', function($scope, $state, pxUserCred, $log) {
    $scope.data = {
      username: '',
      password: '',
      error: ""
    };
    $scope.state = {
      isLoading: true,
      loginPage: false,
      error: false
    };
    pxUserCred.confirmCreds(function(res) {
      $log.info("got result for confirmation as : " + res);
      $scope.state.isLoading = false;
      if (!res) {
        return $scope.state.loginPage = true;
      } else {
        return $state.go('tab.redeem');
      }
    });
    return $scope.submit = function() {
      $scope.state.isLoading = true;
      $scope.state.error = false;
      return pxUserCred.login($scope.data.username, $scope.data.password, function(res) {
        $scope.state.isLoading = false;
        if (!res) {
          $scope.state.error = true;
          $scope.state.loginPage = true;
          if (!res.hasOwnProperty('error')) {
            return $scope.data.error = "Login failed";
          } else {
            return $scope.data.error = "Server error: " + res.error;
          }
        } else {
          $state.go('tab.redeem');
          $scope.data.username = '';
          return $scope.data.password = '';
        }
      });
    };
  }).controller('MainCtrl', function($scope, $rootScope, $state, pxUserCred, pxBadgeProvider, $log, $ionicSideMenuDelegate) {
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
    pxBadgeProvider.setUpdater(callback);
    return $rootScope.$on('$stateChangeStart', function(event, toState, toParams, fromState, fromParams) {
      $log.info("Changing state from " + fromState.name + " to " + toState.name);
      if (toState.name === 'login' || toState.name === 'change_pass') {
        return $scope.state.sideBar = false;
      } else {
        return $scope.state.sideBar = true;
      }
    });
  }).controller('SideBarCtrl', function($scope, pxUserCred, $state, $ionicSideMenuDelegate) {
    $scope.state = {
      registered: false
    };
    $scope.data = {
      title: "Perkkx",
      vendor_id: '',
      vendor_name: ''
    };
    pxUserCred.register(function(id, name, username) {
      $scope.data.vendor_id = id;
      $scope.data.vendor_name = name;
      $scope.data.username = username;
      return $scope.state.registered = true;
    });
    return $scope.logout = function() {
      $scope.state.registered = false;
      $ionicSideMenuDelegate.toggleLeft(false);
      pxUserCred.logout();
      return $state.go('login');
    };
  }).controller('RedeemCtrl', function($log, $scope, pxApiConnect, pxBadgeProvider) {

    /*
      Controller for the first tab,
      used to search for the coupon and showing the deal
     */
    var callback, clearState;
    $scope.data = {
      rcode: "",
      resultCode: ""
    };
    $scope.state = {
      isLoading: false,
      isError: false,
      haveResult: false,
      billshow: false
    };
    clearState = function() {
      $scope.state.isLoading = false;
      $scope.state.isError = false;
      $scope.state.haveResult = false;
      return $scope.state.billshow = false;
    };
    callback = function(data) {
      $scope.state.isLoading = false;
      $log.debug("data : " + (JSON.stringify(data)));
      if (data.valid) {
        $scope.data.resultCode = data.data;
        $scope.state.haveResult = true;
        return $scope.state.billshow = true;
      } else {
        $log.debug("else part");
        return $scope.state.isError = true;
      }
    };
    $scope.clearInput = function() {
      $log.debug('clearing');
      clearState();
      return $scope.data.rcode = "";
    };
    $scope.checkCode = function() {
      var rcode;
      rcode = $scope.data.rcode;
      if (rcode.length === 8) {
        $scope.state.isLoading = true;
        return pxApiConnect.apiCheckValid(rcode, callback);
      } else {
        return clearState();
      }
    };
    $scope.submit = function(data) {
      $scope.state.isLoading = true;
      $log.debug("submitting data: " + data);
      return pxApiConnect.apiSubmit(data)["finally"](function() {
        $scope.clearInput();
        return pxBadgeProvider.refresh();
      });
    };
    return $scope.$watch(function() {
      return $scope.data.rcode;
    }, function(new_val, old_val) {
      if (new_val.length > 8) {
        return $scope.data.rcode = old_val;
      }
    });
  }).controller('UsedCtrl', function($scope, pxApiConnect, $log, pxBadgeProvider, pxUserCred) {

    /*
      Controller for tab 2,
      Shows the used codes
     */
    $scope.codes = [];
    $scope.initGet = function() {
      $log.debug("Init get for used called");
      return pxApiConnect.apiGet('used');
    };
    $scope.refresh = function() {
      return $scope.initGet()["finally"](function() {
        return $scope.$broadcast('scroll.refreshComplete');
      });
    };
    $scope.loadMore = function() {
      var res;
      res = pxApiConnect.apiMore('used');
      if (res.more) {
        return res.future["finally"](function() {
          return $scope.$broadcast('scroll.infiniteScrollComplete');
        });
      } else {
        return $scope.$broadcast('scroll.infiniteScrollComplete');
      }
    };
    $scope.submit = function(data) {
      return pxApiConnect.apiSubmit(data)["finally"](function() {
        return pxBadgeProvider.refresh();
      });
    };
    pxApiConnect.setCallBack('used', function(data, more) {
      var i, len, obj, results;
      if (more) {
        results = [];
        for (i = 0, len = data.length; i < len; i++) {
          obj = data[i];
          results.push($scope.codes.push(obj));
        }
        return results;
      } else {
        return $scope.codes = data;
      }
    });
    pxBadgeProvider.register(function() {
      return $scope.initGet();
    });
    return pxUserCred.register(function() {
      return $scope.initGet();
    });
  }).controller('PendingCtrl', function($log, $scope, pxApiConnect, pxBadgeProvider, pxUserCred) {

    /*
      Last tab, used to show pending codes,
      NOTE: pending codes are actually disputed codes
     */
    $scope.codes = [];
    $scope.initGet = function() {
      return pxApiConnect.apiGet('disputed');
    };
    $scope.refresh = function() {
      return $scope.initGet()["finally"](function() {
        return $scope.$broadcast('scroll.refreshComplete');
      });
    };
    $scope.loadMore = function() {
      var res;
      res = pxApiConnect.apiMore('disputed');
      if (res.more) {
        return res.future["finally"](function() {
          return $scope.$broadcast('scroll.infiniteScrollComplete');
        });
      } else {
        return $scope.$broadcast('scroll.infiniteScrollComplete');
      }
    };
    $scope.submit = function(data) {
      return pxApiConnect.apiSubmit(data)["finally"](function() {
        return pxBadgeProvider.refresh();
      });
    };
    pxApiConnect.setCallBack('disputed', function(data, more) {
      var i, len, obj, results;
      if (more) {
        results = [];
        for (i = 0, len = data.length; i < len; i++) {
          obj = data[i];
          results.push($scope.codes.push(obj));
        }
        return results;
      } else {
        return $scope.codes = data;
      }
    });
    pxBadgeProvider.register(function() {
      return $scope.initGet();
    });
    return pxUserCred.register(function() {
      return $scope.initGet();
    });
  });

}).call(this);
