angular.module 'perkkx.services', []
.factory 'pxApiConnect', ($http, $log) ->
  vendor_id = 1
  baseUrl = 'http://45.55.72.208/perkkx/merchantapp/'
  urls =
    pending: "#{baseUrl}pending/#{vendor_id}"
    used: "#{baseUrl}used/#{vendor_id}"
    expired: "#{baseUrl}expired/#{vendor_id}"
    disputed: "#{baseUrl}disputed/#{vendor_id}"

  callbacks = {}

  refreshData =
    pending: { total: 0, page: 0 }
    used: { total: 0, page: 0 }
    expired: { total: 0, page: 0 }
    disputed: { total: 0, page: 0 }

  res =
    setCallBack: (key, receiver) ->
      callbacks[key] = receiver

    apiGet: (key) ->
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

    apiMore: (key) ->
      if refreshData[key].page < refreshData[key].total
        refreshData[key].page += 1
        res = $http.get "#{urls[key]}?page=#{refreshData[key].page}"
        .success (sdata) ->
          if not sdata.error
            callbacks[key](sdata.data, true)     # refresh
        {more: true, future: res}
      else {more: false}

    apiSubmit: (data) ->
      $http.post "#{baseUrl}submit/#{vendor_id}", data, {
        headers: { "Access-Control-Allow-Origin": true }
      }
      .success () ->
        console.log "heooo"
