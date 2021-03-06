// angular.module is a global place for creating, registering and retrieving Angular modules
// 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'
// 'starter.services' is found in services.js
// 'starter.controllers' is found in controllers.js

angular.module('perkkx', ['ionic', 'ngCordova',
  'perkkx.services', 'perkkx.constants', 'perkkx.directives',
  'perkkx.controllers.main', 'perkkx.controllers.views', 'perkkx.controllers.credentials'
])

.run(function($ionicPlatform, $ionicPopup, $cordovaNetwork) {
  $ionicPlatform.ready(function() {
    if($cordovaNetwork.isOffline()) {
      $ionicPopup.alert({
        title: "Internet Disconnected",
        content: "Perkkx needs an active internet connection to work, please check your connection and relaunch the application",
        okType: 'button-clear button-small button-assertive',
        cancelType: 'button-clear button-small'
      })
      .then(function() {
        navigator.app.exitApp()
      });
    }
    // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    // for form inputs)
    if (window.cordova && window.cordova.plugins && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
    }
    if (window.StatusBar) {
      // org.apache.cordova.statusbar required
      StatusBar.styleLightContent();
    }
    //navigator.splashscreen.hide()
  });
})

.config(function($stateProvider, $urlRouterProvider, $ionicConfigProvider) {

  $ionicConfigProvider.navBar.alignTitle('center');

  // Ionic uses AngularUI Router which uses the concept of states
  // Learn more here: https://github.com/angular-ui/ui-router
  // Set up the various states which the app can be in.
  // Each state's controller can be found in controllers.js
  $stateProvider

  // setup an abstract state for the tabs directive
    .state('tab', {
    url: "/tab",
    abstract: true,
    templateUrl: "templates/tabs.html"
  })

  // Each tab has its own nav history stack:

  .state('tab.redeem', {               // Redeem functionality
    url: '/redeem',
    views: {
      'tab-redeem': {
        templateUrl: 'templates/tab-redeem.html',
        controller: 'RedeemCtrl'
      }
    }
  })
  .state('tab.used', {
    url: '/used',
    views: {
      'tab-used': {
        templateUrl: 'templates/tab-used.html',
        controller: 'UsedCtrl'
      }
    }
  })
  .state('tab.pending', {               // Merchant sees this as pending
    url: '/pending',
    views: {
      'tab-pending': {
        templateUrl: 'templates/tab-pending.html',
        controller: 'PendingCtrl'
      }
    }
  })
  .state('login', {
    url: '/login',
    templateUrl: 'templates/login.html',
    controller: 'LoginCtrl'
  })
  .state('change_pass',{
    url: '/change_pass',
    templateUrl: 'templates/change_pass.html',
    controller: 'ChangePassCtrl'
  });
      /*
      .state('tab.expired', {
        url: '/expired',
        views: {
          'tab-expired': {
            templateUrl: 'templates/tab-expired.html',
            controller: 'ExpiredCtrl'
          }
        }
      }) */

  // if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise('/login');

});
