angular.module 'perkkx.services', []
.factory 'pxDateCheck', () ->
  # Simple factory for checking whether we should allow the slider to be displayed
  # not, deprecated, as we have no slider now
  return (data) ->             # milliseconds
    rDate = moment(data).add(1, 'd').hour(5).minute(0).second(0)
    return moment() > rDate


.factory 'pxApiConnect', ($http, $log, pxApiEndpoints, vendor_id, $cordovaToast) ->
  # Api connection for the main get and post methods
  urls =
    pending: "#{pxApiEndpoints.get}/pending/#{vendor_id}"
    used: "#{pxApiEndpoints.get}/used/#{vendor_id}"
    expired: "#{pxApiEndpoints.get}/expired/#{vendor_id}"
    disputed: "#{pxApiEndpoints.get}/disputed/#{vendor_id}"

  callbacks = {}

  refreshData =
    pending: { total: 0, page: 0 }
    used: { total: 0, page: 0 }
    expired: { total: 0, page: 0 }
    disputed: { total: 0, page: 0 }

  res =
    setCallBack: (key, receiver) ->     # Set the callback function against a url
      callbacks[key] = receiver

    apiGet: (key) ->                    # Get data
      console.log "GET for #{key}"
      res = $http.get urls[key]
      .success (sdata) ->
        if not sdata.error
          refreshData[key].total = sdata.total_pages      # Total # of pages
          refreshData[key].page = sdata.page              # current page
          callbacks[key](sdata.data, false)
        else
          console.log "Got error for GET: #{key}: #{sdata}"
      res

    apiMore: (key) ->                    # for infinite scroll, get more data
      if refreshData[key].page < refreshData[key].total
        refreshData[key].page += 1
        res = $http.get "#{urls[key]}?page=#{refreshData[key].page}"
        .success (sdata) ->
          if not sdata.error
            callbacks[key](sdata.data, true)     # refresh
        {more: true, future: res}
      else {more: false}

    apiSubmit: (data) ->                  # submit bill info
      res = $http.post "#{pxApiEndpoints.post}/#{vendor_id}", data       # TODO: change
      .success (data) ->
        $cordovaToast.show "Bill submitted successfully", "short", "center"
      res

    apiCheckValid: (code, callback) ->    # for redeem tab, check if a ginen rcode is valid
       $http.get "#{pxApiEndpoints.checkValid}?rcode=#{code}&vendor_id=#{vendor_id}"
       .success (data, status) ->
         $log.debug "Response: #{data}"
         callback(data)

.factory 'pxBadgeProvider', ($http, $log, pxApiEndpoints, vendor_id) ->
  # Simple factory for badge work
  url = "#{pxApiEndpoints.badge}/#{vendor_id}"

  callbacks = {}
  updater = {}

  res =
    update: () -> return $http.get url

    setCallBack: (key, receiver) ->
      callbacks[key] = receiver

    setUpdater: (receiver) ->
      updater = receiver

    refresh: () ->
      v() for k, v of callbacks
      updater()

    updateAll: () -> updater()


