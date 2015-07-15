angular.module 'perkkx.services', []
.factory 'pxDateCheck', () ->
  # Simple factory for checking whether we should allow the slider to be displayed
  # not, deprecated, as we have no slider now
  return (data) ->             # milliseconds
    rDate = moment(data).add(1, 'd').hour(5).minute(0).second(0)
    return moment() > rDate

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



.factory 'pxApiConnect', ($http, $log, pxApiEndpoints, pxUserCred, $cordovaToast) ->
  # Api connection for the main get and post methods

  vendor_id = pxUserCred.vendor_id    # A function
  urls =
    pending: "#{pxApiEndpoints.get}/pending/"
    used: "#{pxApiEndpoints.get}/used/"
    expired: "#{pxApiEndpoints.get}/expired/"
    disputed: "#{pxApiEndpoints.get}/disputed/"

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
      res = $http.get urls[key] + vendor_id()
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
        res = $http.get "#{urls[key]}#{vendor_id()}?page=#{refreshData[key].page}"
        .success (sdata) ->
          if not sdata.error
            callbacks[key](sdata.data, true)     # refresh
        {more: true, future: res}
      else {more: false}

    apiSubmit: (data) ->                  # submit bill info
      res = $http.post "#{pxApiEndpoints.post}/#{vendor_id()}", data       # TODO: change
      .success (data) ->
        $cordovaToast.show "Bill submitted successfully", "short", "center"
      res

    apiCheckValid: (code, callback) ->    # for redeem tab, check if a ginen rcode is valid
       $http.get "#{pxApiEndpoints.checkValid}?rcode=#{code}&vendor_id=#{vendor_id()}"
       .success (data, status) ->
         $log.debug "Response: #{data}"
         callback(data)


.factory 'pxUserCred', ($window, $http, pxApiEndpoints, $log) ->
  $log.info "pxUserInitialized"
  storeCred = (vendor, id, pass) ->
    obj =
      vendor_name: vendor
      vendor_id: id          # Not sure if it is vendor_id or username
      password: pass
    $window.localStorage['perkkx_creds'] = JSON.stringify(obj)

  vendor_id_mem = 1            # in memory vendor_id constant
  loggedIn = false

  getCred = () ->
    d = $window.localStorage['perkkx_creds']
    if d
      return JSON.parse(d)
    else return {}

  userLogin = (user, pass) ->
    $http.post pxApiEndpoints.loginProxy, {mode: "login", vendor_id: parseInt(user), password: pass}      # Just to be safe

  changePassword = (user, pass, pass_old) ->
    $http.post pxApiEndpoints.login, {mode: "change_pass", vendor_id: parseInt(user), password: pass, password_old: pass_old}

  res =
    confirmCreds: (callback) ->           # Confirm that the stuff we have in local storage is correct. Results in true or false
      d = getCred()
      if d.hasOwnProperty('vendor_id')
        userLogin(d.vendor_id, d.password).success (data) ->
          callback(data.result)
          vendor_id_mem = d.vendor_id     # OPTIMISTIC
          $log.info "Got login data: "+JSON.stringify(data)
      else
        callback(false)

    login: (id, pass, callback) ->        # Do a login taking things from the login page
      userLogin(id, pass).success (data) ->
        if data.result
          storeCred(data.vendor_name, id, pass)
          vendor_id_mem = id
        callback(data.result)

    vendor_id: () -> vendor_id_mem
    status: () -> loggedIn

  ### NOTES
    We can use confirmCreds and wait to clear the splash screen
    any kind of loading spinners to be handled by the callback functions
  ###
