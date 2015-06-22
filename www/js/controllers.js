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
.controller('DisputeCtrl', function($scope) {})
.controller('PendingCtrl', function($scope,usedcode) {
	$scope.ucodes = usedcode.all();
	$scope.remove= function(item) {
		usedcode.remove(item);
		
	}
	
})

.controller('UsedCtrl', function($scope, Chats) {
  $scope.chats = Chats.all();
  $scope.remove = function(chat) {
    Chats.remove(chat);
	
  }
  
})
/*
.controller('ChatDetailCtrl', function($scope, $stateParams, Chats) {
  $scope.chat = Chats.get($stateParams.chatId);
}) */

.controller('ExpiredCtrl', function($scope) {
  $scope.settings = {
    enableFriends: true
  };
});
