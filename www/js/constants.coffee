angular.module 'perkkx.constants', []
.constant 'pxApiEndpoints',     # TODO
    checkValid: 'http://45.55.72.208/perkkx/merchantapp/validate'
    post: 'http://45.55.72.208/perkkx/merchantapp/submit'     # Actual Post api
    postProxy: 'http://localhost:8100/submit'                 # Proxy for ionic serve
    get: 'http://45.55.72.208/perkkx/merchantapp'     # Add pending and all that
    badge: 'http://45.55.72.208/perkkx/merchantapp/count'       # add vendor id

.constant 'pxApiEndpointso',   # TODO
    checkValid: 'http://localhost:8100/lvalidate',
    post: 'http://localhost:8100/lsubmit',    # Actual Post api
    postProxy: 'http://localhost:8100/lsubmit',    # Actual Post api
    get: 'http://localhost:8100/merchantapp'     # Add pending and all that
    badge: 'http://localhost:8100/lcount'       # add vendor id

.constant 'vendor_id', 1

