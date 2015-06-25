/** API assumptions
 * Codes: { rcode: "", deal: "", expiry: "", used_on: "" }
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
            rcode: "ABC",
            deal: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
            used_on: Date.now()
        },
        {
            rcode: "AB2C",
            deal: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
            used_on: Date.now()
        },
        {
            rcode: "AdqBC",
            deal: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
            used_on: Date.now()
        },
        {
            rcode: "xdAC",
            deal: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
            used_on: Date.now()
        },
        {
            rcode: "sdAsdb",
            deal: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
            used_on: Date.now()
        },
        {
            rcode: "xdfABC",
            deal: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
            used_on: Date.now()
        },
        {
            rcode: "ABC",
            deal: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
            used_on: Date.now()
        }
    ]
    $scope.fullSubmit = function(codeObj) {
        return function(billObj) {
            $scope.submit(billObj);     // Temporary
        }
    }
            

    // adding bill
    $scope.submit = function(obj) {     // TODO
        /* The object is probably as follows: 
           the object from $scope.pcodes array appended with the field:
           invalid: <Boolean>,
           paid: Number,
           discount: Number

          This function will use an external service to confirm the rcode
        */
        alert(JSON.stringify(obj));
    };
    $scope.alert = function(str) {
        alert(str)
    }
})
.controller('UsedCtrl', function($scope){
    $scope.ucodes = [
        {
            rcode: "ABC",
            deal: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
            used_on: Date.now(),

            paid: 1000,
            discount: 205,
            submitted_on: Date.now()
        },
        {
            rcode: "AB2C",
            deal: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
            used_on: Date.now(),

            paid: 1000,
            discount: 205,
            submitted_on: Date.now()
        },
        {
            rcode: "AdqBC",
            deal: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
            used_on: Date.now(),

            paid: 1000,
            discount: 205,
            submitted_on: Date.now()
        },
        {
            rcode: "xdAC",
            deal: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
            used_on: Date.now(),

            paid: 1000,
            discount: 205,
            submitted_on: Date.now()
        }
    ]
    $scope.submit = function(obj) {     // TODO
        alert(JSON.stringify(obj));
    };
})
.controller('ExpiredCtrl', function($scope){
    $scope.ecodes = [
        {
            rcode: "ABC",
            deal: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
        },
        {
            rcode: "AB2C",
            deal: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
        },
        {
            rcode: "AdqBC",
            deal: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
        },
        {
            rcode: "xdAC",
            deal: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
        }
    ]
    $scope.submit = function(obj) {     // TODO
        alert(JSON.stringify(obj));
    };
})
.controller('DisputeCtrl', function($scope){
    $scope.dcodes = [
        {
            rcode: "ABC",
            deal: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
            used_on: Date.now(),

            submitted_on: Date.now()
        },
        {
            rcode: "AB2C",
            deal: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
            used_on: Date.now(),

            submitted_on: Date.now()
        },
        {
            rcode: "AdqBC",
            deal: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
            used_on: Date.now(),

            submitted_on: Date.now()
        },
        {
            rcode: "xdAC",
            deal: "Get 50% off on minimum perchase of some stuff",
            expiry: Date.now(),
            used_on: Date.now(),

            submitted_on: Date.now()
        }
    ]

});
