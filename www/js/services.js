// Generated by CoffeeScript 1.9.3
(function() {
  angular.module('perkkx.services', []).constant('pxApiEndpoints', {
    checkValid: 'http://45.55.72.208/perkkx/merchantapp/validate?rcode=',
    post: 'http://45.55.72.208/perkkx/merchantapp/submit',
    postProxy: 'http://localhost:8100/submit',
    get: 'http://45.55.72.208/perkkx/merchantapp'
  }).constant('pxApiEndpointso', {
    checkValid: 'http://localhost:8100/lvalidate?rcode=',
    post: 'http://localhost:8100/lsubmit',
    postProxy: 'http://localhost:8100/lsubmit',
    get: 'http://localhost:8100/merchantapp'
  }).constant('vendor_id', 1).factory('pxDateCheck', function($log) {
    return function(data) {
      var rDate;
      rDate = moment(data).add(1, 'd').hour(5).minute(0).second(0);
      return moment() > rDate;
    };
  }).factory('pxApiConnect', function($http, $log, pxApiEndpoints, vendor_id) {
    var callbacks, refreshData, res, urls;
    urls = {
      pending: pxApiEndpoints.get + "/pending/" + vendor_id,
      used: pxApiEndpoints.get + "/used/" + vendor_id,
      expired: pxApiEndpoints.get + "/expired/" + vendor_id,
      disputed: pxApiEndpoints.get + "/disputed/" + vendor_id
    };
    callbacks = {};
    refreshData = {
      pending: {
        total: 0,
        page: 0
      },
      used: {
        total: 0,
        page: 0
      },
      expired: {
        total: 0,
        page: 0
      },
      disputed: {
        total: 0,
        page: 0
      }
    };
    return res = {
      setCallBack: function(key, receiver) {
        return callbacks[key] = receiver;
      },
      apiGet: function(key) {
        console.log("GET for " + key);
        res = $http.get(urls[key]).success(function(sdata) {
          if (!sdata.error) {
            refreshData[key].total = sdata.total_pages;
            refreshData[key].page = sdata.page;
            return callbacks[key](sdata.data, false);
          } else {
            return console.log("Got error for GET: " + key + ": " + sdata);
          }
        });
        return res;
      },
      apiMore: function(key) {
        if (refreshData[key].page < refreshData[key].total) {
          refreshData[key].page += 1;
          res = $http.get(urls[key] + "?page=" + refreshData[key].page).success(function(sdata) {
            if (!sdata.error) {
              return callbacks[key](sdata.data, true);
            }
          });
          return {
            more: true,
            future: res
          };
        } else {
          return {
            more: false
          };
        }
      },
      apiSubmit: function(data) {
        res = $http.post(pxApiEndpoints.postProxy + "/" + vendor_id, data).success(function() {
          return $log.debug("Post successfull");
        });
        return res;
      },
      apiCheckValid: function(code, callback) {
        return $http.get("" + pxApiEndpoints.checkValid + code).success(function(data, status) {
          $log.debug("Response: " + data);
          return callback(data);
        });
      }
    };
  });

}).call(this);
