// Generated by CoffeeScript 1.9.3
(function() {
  angular.module('perkkx.services', []).factory('pxDateCheck', function() {
    return function(data) {
      var rDate;
      rDate = moment(data).add(1, 'd').hour(5).minute(0).second(0);
      return moment() > rDate;
    };
  }).factory('pxBadgeProvider', function($http, $log, pxApiEndpoints, vendor_id) {
    var callbacks, res, updater, url;
    url = pxApiEndpoints.badge + "/" + vendor_id;
    callbacks = {};
    updater = {};
    return res = {
      update: function() {
        return $http.get(url);
      },
      setCallBack: function(key, receiver) {
        return callbacks[key] = receiver;
      },
      setUpdater: function(receiver) {
        return updater = receiver;
      },
      refresh: function() {
        var k, v;
        for (k in callbacks) {
          v = callbacks[k];
          v();
        }
        return updater();
      },
      updateAll: function() {
        return updater();
      }
    };
  }).factory('pxApiConnect', function($http, $log, pxApiEndpoints, pxUserCred, $cordovaToast) {
    var callbacks, refreshData, res, urls, vendor_id;
    vendor_id = 0;
    pxUserCred.register(function(id, name) {
      return vendor_id = parseInt(id);
    });
    urls = {
      pending: pxApiEndpoints.get + "/pending/",
      used: pxApiEndpoints.get + "/used/",
      expired: pxApiEndpoints.get + "/expired/",
      disputed: pxApiEndpoints.get + "/disputed/"
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
        res = $http.get(urls[key] + vendor_id).success(function(sdata) {
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
          res = $http.get("" + urls[key] + vendor_id + "?page=" + refreshData[key].page).success(function(sdata) {
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
        res = $http.post(pxApiEndpoints.post + "/" + vendor_id, data).success(function(data) {
          return $cordovaToast.show("Bill submitted successfully", "short", "center");
        });
        return res;
      },
      apiCheckValid: function(code, callback) {
        return $http.get(pxApiEndpoints.checkValid + "?rcode=" + code + "&vendor_id=" + vendor_id).success(function(data, status) {
          $log.debug("Response: " + data);
          return callback(data);
        });
      }
    };
  }).factory('pxUserCred', function($window, $http, pxApiEndpoints, $log) {
    var announce, callbacks, changePassword, getCred, res, storeCred, userLogin;
    $log.info("pxUserInitialized");
    storeCred = function(vendor, id, pass) {
      var obj;
      obj = {
        vendor_name: vendor,
        vendor_id: id,
        password: pass
      };
      return $window.localStorage['perkkx_creds'] = JSON.stringify(obj);
    };
    callbacks = [];
    getCred = function() {
      var d;
      d = $window.localStorage['perkkx_creds'];
      if (d) {
        return JSON.parse(d);
      } else {
        return {};
      }
    };
    announce = function() {
      var call, d, i, len, results;
      d = getCred();
      if (d.hasOwnProperty('vendor_id')) {
        results = [];
        for (i = 0, len = callbacks.length; i < len; i++) {
          call = callbacks[i];
          results.push(call(d.vendor_id, d.vendor_name));
        }
        return results;
      }
    };
    userLogin = function(user, pass) {
      return $http.post(pxApiEndpoints.loginProxy, {
        mode: "login",
        vendor_id: parseInt(user),
        password: pass
      });
    };
    changePassword = function(user, pass, pass_old) {
      return $http.post(pxApiEndpoints.login, {
        mode: "change_pass",
        vendor_id: parseInt(user),
        password: pass,
        password_old: pass_old
      });
    };
    return res = {
      confirmCreds: function(callback) {
        var d;
        d = getCred();
        if (d.hasOwnProperty('vendor_id')) {
          return userLogin(d.vendor_id, d.password).success(function(data) {
            callback(data.result);
            announce();
            return $log.info("Got login data: " + JSON.stringify(data));
          });
        } else {
          return callback(false);
        }
      },
      login: function(id, pass, callback) {
        return userLogin(id, pass).success(function(data) {
          if (data.result) {
            storeCred(data.vendor_name, id, pass);
            announce();
          }
          return callback(data.result);
        });
      },
      register: function(receiver) {
        callbacks.push(receiver);
        return announce();
      },
      logout: function() {
        delete $window.localStorage['perkkx_creds'];
        return alert("wow");
      }
    };

    /* NOTES
      We can use confirmCreds and wait to clear the splash screen
      any kind of loading spinners to be handled by the callback functions
     */
  });

}).call(this);
