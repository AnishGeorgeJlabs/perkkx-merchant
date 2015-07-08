// Generated by CoffeeScript 1.9.3
(function() {
  var hasProp = {}.hasOwnProperty;

  angular.module('perkkx.controllers', []).controller('BadgeCtrl', function($scope, pxBadgeProvider, $log) {
    var callback;
    $log.info("initialized BadgeCtrl");
    $scope.badges = {
      used: 0,
      disputed: 0
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
    $scope.updateAll = function() {
      return pxBadgeProvider.update().success(function(data) {
        return callback(data);
      });
    };
    return $scope.updateAll();
  }).controller('PendingCtrl', function($log, $scope, pxApiConnect, pxBadgeProvider) {
    var clearState;
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
        return pxApiConnect.apiCheckValid(rcode, $scope.callback);
      } else {
        return clearState();
      }
    };
    $scope.callback = function(data) {
      $scope.state.isLoading = false;
      $log.debug("data : " + (JSON.stringify(data)));
      if (data.valid) {
        $scope.data.resultCode = data.data;
        return $scope.state.haveResult = true;
      } else {
        $log.debug("else part");
        return $scope.state.isError = true;
      }
    };
    $scope.submit = function(data) {
      $scope.state.isLoading = true;
      $log.debug("submitting data: " + data);
      return pxApiConnect.apiSubmit(data)["finally"](function() {
        $scope.clearInput();
        $scope.$parent.updateAll();
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
  }).controller('UsedCtrl', function($scope, pxApiConnect, $log, pxBadgeProvider) {
    $scope.codes = [];
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
    pxBadgeProvider.setCallBack('used', function() {
      return $scope.initGet();
    });
    $scope.initGet = function() {
      $log.debug("Init get for used called");
      return pxApiConnect.apiGet('used');
    };
    $scope.initGet();
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
    return $scope.submit = function(data) {
      return pxApiConnect.apiSubmit(data)["finally"](function() {
        return pxBadgeProvider.refresh();
      });
    };
  }).controller('DisputeCtrl', function($log, $scope, pxApiConnect, pxBadgeProvider) {
    $log.debug("Initialised Dispute ctrl");
    $scope.codes = [];
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
    pxBadgeProvider.setCallBack('disputed', function() {
      return initGet();
    });
    $scope.initGet = function() {
      return pxApiConnect.apiGet('disputed');
    };
    $scope.initGet();
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
    return $scope.submit = function(data) {
      return pxApiConnect.apiSubmit(data)["finally"](function() {
        return pxBadgeProvider.refresh();
      });
    };
  });


  /*
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
   */

}).call(this);
