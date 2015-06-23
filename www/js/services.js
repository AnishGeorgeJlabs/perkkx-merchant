angular.module('perkkx.services', [])
.factory('pxApiConnect', function($http, $log) {
    var vendor_id = 1;
    var urls = {            // TODO
        pending: "todo",
        used: "todo",
        expired: "todo",
        disputed: "todo"
    }

    /* Currently, not employing the error callback */
    var callbacks = {
        pending: function(data) {},
        used: function(data) {},
        expired: function(data) {},
        disputed: function(data) {}
    }

    var res = {
        setCallback: function(key, receiver) {
            callbacks[key] = receiver;
        },
        apiGet: function(key) {
            // Use $http service to call the api
            $http.jsonp(urls[key])
            .success( function(data) { callbacks[key](data) })
        }
    }
        
});


/*
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
}); */
