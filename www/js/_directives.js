angular.module('perkkx.directives', [])
.directive('pxCouponHeader', function() {
    return {
        restrict: 'E',
        templateUrl: 'directives/coupon-header.html',
        scope: {
            coupon: '=coupon'
        }
    };
})
.directive('pxCoupon', function() {
    return {
        restrict: 'E',
        templateUrl: 'directives/coupon.html',
        scope: {
            coupon: '=coupon',
            hRedeem: '=redeem',
            hExpiry: '=expiry',
            hBill: '=bill'
        }
    };
})

.directive('pxBillForm', function(pxDateCheck) {
    return {
        restrict: 'E',
        scope: {
            submitFunc: '=submitFunc',      // Submission function
            formshow: '=show',              // variable to decide if the form is shown or not
            submitObj: '=submitObj',        // The object to be merged with result and submitted
            defPaid: '=defaultPaid',
            defDiscount: '=defaultDiscount',
            slider: '=slider'
        },
        compile: function(elem, attr) {
            if (!attr.defaultPaid) { attr.defaultPaid = '0' }
            if (!attr.defaultDiscount) { attr.defaultDiscount = '0' }
            if (!attr.slider) { attr.slider = 'true' }
        },
        controller: function($scope, pxDateCheck) {
            $scope.sliderCheck = function() {
                return $scope.slider && pxDateCheck($scope.submitObj.used_on)
            }
            var cleanup = function() {
                $scope.paid = parseInt($scope.defPaid);
                $scope.discount = parseInt($scope.defDiscount);
                $scope.invalid = false;
            }
            cleanup()    
            $scope.cancel = function() {
                cleanup();
                $scope.formshow = false;
            }
            $scope.submit = function() {
                var res = {};
                if ($scope.invalid) {
                    res = { status: "expired" }
                } else {
                    res = {
                        status: "used",
                        paid: $scope.paid,
                        discount: $scope.discount
                    };
                }
                res.submitted_on = parseInt(Date.now() / 1000);
                res.cID = $scope.submitObj.cID;
                res.rcode = $scope.submitObj.rcode;
                res.userID = $scope.submitObj.userID
                $scope.submitFunc(res)
                $scope.formshow = false;
            }
        },
        templateUrl: 'directives/bill-form.html'
    };
});
