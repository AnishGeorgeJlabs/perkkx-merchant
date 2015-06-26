// Generated by CoffeeScript 1.9.3
(function() {
  angular.module('perkkx.controllers', []).controller('BadgeCtrl', function($scope) {
    console.log("initialized BadgeCtrl");
    $scope.badges = {
      pending: 0,
      used: 0,
      expired: 0,
      disputed: 0
    };
    return $scope.updateBadge = function(key, num) {
      if ($scope.badges.hasOwnProperty(key) && num >= 0) {
        return $scope.badges[key] = num;
      }
    };
  }).controller('PendingCtrl', function($scope, pxApiConnect) {
    $scope.codes = [];
    pxApiConnect.setCallBack('pending', function(data, more) {
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
    $scope.initGet = function() {
      return pxApiConnect.apiGet('pending');
    };
    $scope.initGet();
    $scope.refresh = function() {
      return $scope.initGet()["finally"](function() {
        return $scope.$broadcast('scroll.refreshComplete');
      });
    };
    $scope.loadMore = function() {
      var res;
      res = pxApiConnect.apiMore('pending');
      if (res.more) {
        return res.future["finally"](function() {
          return $scope.$broadcast('scroll.infiniteScrollComplete');
        });
      } else {
        return $scope.$broadcast('scroll.infiniteScrollComplete');
      }
    };
    return $scope.submit = function(data) {
      pxApiConnect.apiSubmit(data);
      return $scope.initGet();
    };
  }).controller('UsedCtrl', function($scope, pxApiConnect) {
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
    $scope.initGet = function() {
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
      pxApiConnect.apiSubmit(data);
      return $scope.initGet();
    };
  }).controller('ExpiredCtrl', function($scope, pxApiConnect) {
    $scope.codes = [];
    pxApiConnect.setCallBack('expired', function(data, more) {
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
    $scope.initGet = function() {
      return pxApiConnect.apiGet('expired');
    };
    $scope.initGet();
    $scope.refresh = function() {
      return $scope.initGet()["finally"](function() {
        return $scope.$broadcast('scroll.refreshComplete');
      });
    };
    $scope.loadMore = function() {
      var res;
      res = pxApiConnect.apiMore('expired');
      if (res.more) {
        return res.future["finally"](function() {
          return $scope.$broadcast('scroll.infiniteScrollComplete');
        });
      } else {
        return $scope.$broadcast('scroll.infiniteScrollComplete');
      }
    };
    return $scope.submit = function(data) {
      pxApiConnect.apiSubmit(data);
      return $scope.initGet();
    };
  }).controller('DisputeCtrl', function($scope, pxApiConnect) {
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
      pxApiConnect.apiSubmit(data);
      return $scope.initGet();
    };
  }).controller('TestCtrl', function($scope) {
    return console.log("Initialised Test");
  });


  /*
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
   */


  /*
  .controller 'TabCtrl', ($scope, pxApiConnect) ->
    $scope.data = []
  
    $scope.setCallBack = (key) ->
      pxApiConnect.setCallBack key, (data, more) ->
        if more
          $scope.data.push obj for obj in data
        else $scope.data = data
  
    $scope.initGet = (key) -> pxApiConnect.getApi key
    $scope.refresh = (key) ->
      $scope.initGet key
      .finally () ->
        $scope.$broadcast 'scroll.refreshComplete'
    $scope.loadMore = (key) ->
      $scope.initGet key
      .finally () ->
        $scope.$broadcast 'scroll.infiniteScrollComplete'
    $scope.submit = (obj) -> pxApiConnect.apiSubmit(obj)
   */

}).call(this);

//# sourceMappingURL=controllers.js.map
