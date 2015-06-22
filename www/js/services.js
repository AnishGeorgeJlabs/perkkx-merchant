angular.module('perkkx.services', [])

.factory('Chats', function($http,$log) {
	var chats=[];
  $http.get("http://jlabs.co/perkkx/code.php",{cache:true})
	.success(function(result){
		angular.copy(result,chats)
		console.log(chats);
	});
   

  return {
    all: function() {
      return chats;
    },
    remove: function(chat) {
      chats.splice(chats.indexOf(chat), 1);
    },
    get: function(chatId) {
      for (var i = 0; i < chats.length; i++) {
        if (chats[i].id === parseInt(chatId)) {
          return chats[i];
        }
      }
      return null;
    }
  };
})


.factory('usedcode', function($http,$log) {
	var ucodes=[];
  $http.get("http://45.55.72.208/perkkx/merchant/coupon/1",{cache:true})
	.success(function(result){
		angular.copy(result.coupons.A1,ucodes)
		console.log(ucodes);
	});
   

  return {
    all: function() {
      return ucodes;
    },
    remove: function(code) {
      ucodes.splice(ucodes.indexOf(code), 1);
    },
    get: function(chatId) {
      for (var i = 0; i < ucodes.length; i++) {
        if (ucodess[i].id === parseInt(chatId)) {
          return ucodes[i];
        }
      }
      return null;
    }
  };
});
