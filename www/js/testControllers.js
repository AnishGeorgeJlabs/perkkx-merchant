/** API assumptions
 * Codes: { code: "", desc: "", expiry: "", usedOn: "" }
 */

angular.module("perkkx.testControllers", [])
.controller('BadgeCtrl', function($scope) {     // Will be a parent controller for all tabs
    $scope.badges = {
        pending: 10,
        used: 0,
        expired: 0,
        disputed: 0
    }
    $scope.updateBadge = function (key, num) {
        if ($scope.badges.hasOwnProperty(key) && num >= 0) {
            $scope.badges[key] = num;
        }
    }
})
.controller('PendingCtrl', function($scope){
    $scope.pcodes = [
        {
            code: "ABC",
            desc: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
            usedOn: Date.now()
        },
        {
            code: "AB2C",
            desc: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
            usedOn: Date.now()
        },
        {
            code: "AdqBC",
            desc: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
            usedOn: Date.now()
        },
        {
            code: "xdAC",
            desc: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
            usedOn: Date.now()
        },
        {
            code: "sdAsdb",
            desc: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
            usedOn: Date.now()
        },
        {
            code: "xdfABC",
            desc: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
            usedOn: Date.now()
        },
        {
            code: "ABC",
            desc: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
            usedOn: Date.now()
        }
    ]

    // adding bill
    $scope.submit = function(obj) {     // TODO
        /* The object is probably as follows: 
           the object from $scope.pcodes array appended with the field:
           invalid: <Boolean>,
           paid: Number,
           discount: Number

          This function will use an external service to confirm the code
        */
        alert(JSON.stringify(obj));
    };
    $scope.alert = function(str) {
        alert(str)
    }
})
.controller('UsedCtrl', function($scope){})
.controller('ExpiredCtrl', function($scope){})
.controller('DisputeCtrl', function($scope){});
