// Generated by CoffeeScript 1.9.3
(function() {
  angular.module('perkkx.services', []).factory('pxBadgeProvider', function($http, $log, pxApiEndpoints, pxUserCred, $ionicScrollDelegate) {
    var callbacks, res, update, updater, vendor_id;
    vendor_id = 0;
    callbacks = [];
    updater = function() {};
    update = function() {
      return $http.get(pxApiEndpoints.badge + "/" + vendor_id);
    };
    res = {
      register: function(receiver) {
        return callbacks.push(receiver);
      },
      setUpdater: function(receiver) {
        return updater = receiver;
      },
      refresh: function() {
        var call, i, len;
        for (i = 0, len = callbacks.length; i < len; i++) {
          call = callbacks[i];
          call();
        }
        $ionicScrollDelegate.scrollTop();
        return update().success(updater);
      },
      updateBadgesOnly: function() {
        return update().success(updater);
      }
    };
    pxUserCred.register(function(d) {
      vendor_id = d.vendor_id;
      return res.refresh();
    });
    return res;
  }).factory('pxApiConnect', function($http, $log, pxApiEndpoints, pxUserCred, $cordovaToast) {
    var callbacks, refreshData, res, urls, vendor_id;
    vendor_id = 0;
    pxUserCred.register(function(d) {
      return vendor_id = parseInt(d.vendor_id);
    }, true);
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
        console.log("GET for " + key + " with vendor: " + vendor_id);
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
          $log.info("Bill submitted successfully: " + JSON.stringify(data));
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
    var announce, callbacks, changePassword, firstLogin, getCred, isLoggedIn, newPassword, res, storeCred, userLogin;
    storeCred = function(username, pass, data) {
      data['username'] = username;
      data['password'] = pass;
      return $window.localStorage['perkkx_creds'] = JSON.stringify(data);
    };
    callbacks = [];
    isLoggedIn = false;
    firstLogin = false;
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
        isLoggedIn = true;
        results = [];
        for (i = 0, len = callbacks.length; i < len; i++) {
          call = callbacks[i];
          results.push(call(d));
        }
        return results;
      }
    };
    userLogin = function(user, pass) {
      return $http.post(pxApiEndpoints.login, {
        mode: "login",
        username: user,
        password: pass
      });
    };
    changePassword = function(user, pass_old, pass_new) {
      return $http.post(pxApiEndpoints.login, {
        mode: "change_pass",
        username: user,
        password: pass_new,
        password_old: pass_old
      });
    };
    newPassword = function(user, pass_new) {
      var d;
      d = getCred();
      return changePassword(user, d.password, pass_new);
    };
    return res = {
      confirmCreds: function(callback) {
        var d;
        d = getCred();
        if (d.hasOwnProperty('vendor_id')) {
          return userLogin(d.username, d.password).success(function(data) {
            firstLogin = !data.verified;
            callback(data.result);
            announce();
            return $log.info("Got login data: " + JSON.stringify(data));
          });
        } else {
          return callback(false);
        }
      },
      login: function(username, pass, callback) {
        var sPass;
        $log.debug("pxUserCred login: " + username + ", " + pass);
        sPass = md5(pass);
        return userLogin(username, sPass).success(function(data) {
          if (data.result) {
            storeCred(username, sPass, data.data);
            announce();
            firstLogin = !data.verified;
          }
          return callback(data.result);
        });
      },
      change_pass: function(username, pass_old, pass_new, callback) {
        return changePassword(username, md5(pass_old), md5(pass_new)).success(function(data) {
          if (data.result) {
            delete $window.localStorage['perkkx_creds'];
          }
          return callback(data.result);
        });
      },
      new_pass: function(username, new_pass, callback) {
        return newPassword(username, md5(new_pass)).success(function(data) {
          if (data.result) {
            delete $window.localStorage['perkkx_creds'];
          }
          return callback(data.result);
        });
      },
      register: function(receiver, priorityFlag) {
        if (priorityFlag) {
          callbacks.unshift(receiver);
        } else {
          callbacks.push(receiver);
        }
        return announce();
      },
      logout: function() {
        delete $window.localStorage['perkkx_creds'];
        return isLoggedIn = false;
      },
      isLoggedIn: function() {
        return isLoggedIn;
      },
      firstLogin: function() {
        return firstLogin;
      }
    };

    /* NOTES
      We can use confirmCreds and wait to clear the splash screen
      any kind of loading spinners to be handled by the callback functions
     */
  });

}).call(this);
