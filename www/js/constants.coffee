baseUrl = 'http://45.55.72.208/perkkx/merchantapp'
angular.module 'perkkx.constants', []
.constant 'pxApiEndpoints',     # TODO
    checkValid: "#{baseUrl}/validate"
    post: "#{baseUrl}/submit"     # Actual Post api
    postProxy: 'http://localhost:8100/submit'                 # Proxy for ionic serve
    get: "#{baseUrl}"     # Add pending and all that
    badge: "#{baseUrl}/count"       # add vendor id
    login: "#{baseUrl}/login"
    loginProxy: "http://localhost:8100/login"

.constant 'pxApiEndpoints_old',   # TODO
    checkValid: 'http://localhost:8100/lvalidate',
    post: 'http://localhost:8100/lsubmit',    # Actual Post api
    postProxy: 'http://localhost:8100/lsubmit',    # Actual Post api
    get: 'http://localhost:8100/merchantapp'     # Add pending and all that
    badge: 'http://localhost:8100/lcount'       # add vendor id

