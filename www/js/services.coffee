angular.module 'perkkx.services', []
.factory 'pxBadgeProvider', ($http, $log, pxApiEndpoints, pxUserCred, $ionicScrollDelegate) ->
# Simple factory for badge work

  vendor_id = 0

  callbacks = []
  updater = () ->

  update = () -> return $http.get "#{pxApiEndpoints.badge}/#{vendor_id}"

  res =
    register: (receiver) ->
      callbacks.push(receiver)

    setUpdater: (receiver) ->
      updater = receiver

    refresh: () ->
      call() for call in callbacks
      $ionicScrollDelegate.scrollTop()
      update().success updater

    updateBadgesOnly: () ->
      update().success updater

  pxUserCred.register (d) ->
    vendor_id = d.vendor_id
    res.refresh()

  return res

.factory 'pxApiConnect', ($http, $log, pxApiEndpoints, pxUserCred, $cordovaToast) ->
  # Api connection for the main get and post methods

  vendor_id = 0
  pxUserCred.register (d) ->
    vendor_id = parseInt(d.vendor_id)    # just to be safe
  , true

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
      console.log "GET for #{key} with vendor: #{vendor_id}"
      res = $http.get urls[key] + vendor_id
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
        res = $http.get "#{urls[key]}#{vendor_id}?page=#{refreshData[key].page}"
        .success (sdata) ->
          if not sdata.error
            callbacks[key](sdata.data, true)     # refresh
        {more: true, future: res}
      else {more: false}

    apiSubmit: (data) ->                  # submit bill info
      res = $http.post "#{pxApiEndpoints.post}/#{vendor_id}", data
      .success (data) ->
        $log.info "Bill submitted successfully: "+JSON.stringify(data)
        $cordovaToast.show "Bill submitted successfully", "short", "center"
      res

    apiCheckValid: (code, callback) ->    # for redeem tab, check if a ginen rcode is valid
       $http.get "#{pxApiEndpoints.checkValid}?rcode=#{code}&vendor_id=#{vendor_id}"
       .success (data, status) ->
         $log.debug "Response: #{data}"
         callback(data)


.factory 'pxUserCred', ($window, $http, pxApiEndpoints, $log) ->
  storeCred = (username, pass, data) ->
    data['username'] = username
    data['password'] = pass
    $window.localStorage['perkkx_creds'] = JSON.stringify(data)

  callbacks = []
  isLoggedIn = false

  getCred = () ->
    d = $window.localStorage['perkkx_creds']
    if d
      return JSON.parse(d)
    else return {}

  announce = () ->
    d = getCred()
    if d.hasOwnProperty('vendor_id')
      isLoggedIn = true
      call(d) for call in callbacks

  userLogin = (user, pass) ->
    $http.post pxApiEndpoints.login, {mode: "login", username: user, password: pass}      # Just to be safe

  changePassword = (user, pass_old, pass_new) ->
    $http.post pxApiEndpoints.login, {mode: "change_pass", username: user , password: pass_new, password_old: pass_old}

  res =
    confirmCreds: (callback) ->           # Confirm that the stuff we have in local storage is correct. Results in true or false
      d = getCred()
      if d.hasOwnProperty('vendor_id')
        userLogin(d.username, d.password).success (data) ->
          callback(data.result)
          announce()
          $log.info "Got login data: "+JSON.stringify(data)
      else
        callback(false)

    login: (username, pass, callback) ->        # Do a login taking things from the login page
      userLogin(username, pass).success (data) ->
        if data.result
          storeCred(username, pass, data.data)
          announce()
        callback(data.result)


    change_pass: (username, pass_old, pass_new, callback) ->
      changePassword(username, pass_old, pass_new).success (data) ->
        if data.result
          delete $window.localStorage['perkkx_creds']
        callback(data.result)

    register: (receiver, priorityFlag) ->       # Will take vendor_id, and vendor_name
      if priorityFlag
        callbacks.unshift(receiver)
      else
        callbacks.push(receiver)
      announce()

    logout: () ->
      delete $window.localStorage['perkkx_creds']
      isLoggedIn = false

    isLoggedIn: () -> isLoggedIn

  ### NOTES
    We can use confirmCreds and wait to clear the splash screen
    any kind of loading spinners to be handled by the callback functions
  ###
