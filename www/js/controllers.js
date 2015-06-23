angular.module('perkkx.controllers', [])

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

.controller('PendingCtrl', function($scope) {
    $scope.pcodes = []
    $scope.submit = function(obj) {};
})

.controller('UsedCtrl', function($scope){
    $scope.ucodes = [];
    $scope.submit = function(obj) {};
})

.controller('ExpiredCtrl', function($scope){
    $scope.ecodes = [];
    $scope.submit = function(obj) {};
});
