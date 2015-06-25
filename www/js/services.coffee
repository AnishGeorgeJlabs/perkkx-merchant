angular.module 'perkkx.services', []
.factory 'pxApiConnect', ($http, $log) ->
  vendor_id = 1
  baseUrl = 'http://45.55.72.208/perkkx/merchantapp/'
  urls =
    pending: "#{baseUrl}pending/#{vendor_id}"
    used: "#{baseUrl}used/#{vendor_id}"
    expired: "#{baseUrl}expired/#{vendor_id}"
    disputed: "#{baseUrl}disputed/#{vendor_id}"

  callbacks =
    pending: ->
    used: ->
    expired: ->
    disputed: ->

  res =
    setCallBack: (key, receiver) ->
      callbacks[key] = receiver

    apiGet: (key) ->
      console.log "apiGet called"
      $http.get urls[key]
      .success (data) -> callbacks[key](data)
