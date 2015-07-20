// Generated by CoffeeScript 1.9.3
(function() {
  angular.module('perkkx.directives', []).directive('pxCoupon', function() {
    return {
      restrict: 'E',
      templateUrl: 'directives/coupon.html',
      scope: {
        coupon: '=coupon',
        hRedeem: '=redeem',
        hExpiry: '=expiry',
        hBill: '=bill'
      },
      controller: function($scope) {
        return $scope.checkExpiry = function(ed) {
          return moment(ed) < moment().add(6, 'M');
        };
      }
    };
  }).directive('pxBillForm', function() {
    return {
      restrict: 'E',
      scope: {
        submitFunc: '=submitFunc',
        formshow: '=show',
        submitObj: '=submitObj',
        defPaid: '=defaultPaid',
        defDiscount: '=defaultDiscount',
        scrollBack: '=scrollBack'
      },
      compile: function(elem, attr) {
        if (!attr.scrollBack) {
          return attr.scrollBack = 'false';
        }
      },
      controller: function($scope, $log, $ionicPopup, $ionicScrollDelegate) {
        var cleanup;
        $scope.dealOptsCheck = function() {
          return $scope.submitObj.hasOwnProperty('dealOpts');
        };
        $scope.data = {
          selectedOpt: {}
        };
        $scope.$watch(function() {
          return $scope.submitObj;
        }, function() {
          if ($scope.dealOptsCheck()) {
            return $scope.data.selectedOpt = $scope.submitObj.dealOpts[$scope.submitObj.selectedIndex];
          }
        });
        cleanup = function() {
          $scope.data.paid = parseInt($scope.defPaid);
          return $scope.data.discount = parseInt($scope.defDiscount);
        };
        cleanup();
        $scope.cancel = function() {
          $scope.formshow = false;
          if ($scope.scrollBack) {
            $ionicScrollDelegate.scrollTop();
          }
          return cleanup();
        };
        $scope.validate = function() {
          var result;
          result = $scope.data.paid > 0 && $scope.data.discount > 0;
          if (!result) {
            $ionicPopup.alert({
              title: 'Unable to submit',
              template: "The bill values you entered are invalid: " + $scope.data.paid + " and " + $scope.data.discount,
              okType: 'button-positive button-small button-clear'
            });
          }
          return result;
        };
        return $scope.submit = function() {
          var res;
          $scope.formshow = false;
          if ($scope.scrollBack) {
            $ionicScrollDelegate.scrollTop();
          }
          res = {
            paid: parseInt($scope.data.paid),
            discount: parseInt($scope.data.discount)
          };
          res.submitted_on = parseInt(Date.now());
          if ($scope.dealOptsCheck()) {
            res.used_on = $scope.submitObj.used_on;
            res.cID = $scope.data.selectedOpt.cID;
          } else {
            res.cID = $scope.submitObj.cID;
          }
          if ($scope.submitObj.hasOwnProperty('cID')) {
            res.orig_cID = $scope.submitObj.cID;
          }
          res.rcode = $scope.submitObj.rcode;
          res.userID = $scope.submitObj.rcode.slice(0, 6);
          cleanup();
          return $scope.submitFunc(res);
        };
      },
      templateUrl: 'directives/bill-form.html'
    };
  });

}).call(this);
