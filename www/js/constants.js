// Generated by CoffeeScript 1.9.3
(function() {
  angular.module('perkkx.constants', []).constant('pxApiEndpointso', {
    checkValid: 'http://45.55.72.208/perkkx/merchantapp/validate',
    post: 'http://45.55.72.208/perkkx/merchantapp/submit',
    postProxy: 'http://localhost:8100/submit',
    get: 'http://45.55.72.208/perkkx/merchantapp',
    badge: 'http://45.55.72.208/perkkx/merchantapp/count'
  }).constant('pxApiEndpoints', {
    checkValid: 'http://localhost:8100/lvalidate',
    post: 'http://localhost:8100/lsubmit',
    postProxy: 'http://localhost:8100/lsubmit',
    get: 'http://localhost:8100/merchantapp',
    badge: 'http://localhost:8100/lcount'
  }).constant('vendor_id', 1);

}).call(this);
