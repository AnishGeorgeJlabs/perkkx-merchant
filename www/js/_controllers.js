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

.controller('PendingCtrl', function($scope, pxApiConnect) {
    $scope.pcodes = []
    pxApiConnect.setCallback('pending', function(data) {
        $scope.$apply(function() {
            $scope.pcodes = data;
        });
    });
    pxApiConnect.apiGet('pending')

    $scope.submit = function(obj) {};
})

.controller('UsedCtrl', function($scope){
    $scope.ucodes = [];
    pxApiConnect.setCallback('used', function(data) {
        $scope.$apply(function() {
            $scope.ucodes = data;
        });
    });
    pxApiConnect.apiGet('used')
    $scope.submit = function(obj) {};
})

.controller('ExpiredCtrl', function($scope){
    $scope.ecodes = [];
    pxApiConnect.setCallback('expired', function(data) {
        $scope.$apply(function() {
            $scope.ecodes = data;
        });
    });
    pxApiConnect.apiGet('expired')
    $scope.submit = function(obj) {};
})

.controller('DisputeCtrl', function($scope) {
    $scope.dcodes = [];
    pxApiConnect.setCallback('disputed', function(data) {
        $scope.$apply(function() {
            $scope.dcodes = data;
        });
    });
    pxApiConnect.apiGet('disputed')
    $scope.submit = function(obj) {};
});
