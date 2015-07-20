baseUrl = 'http://45.55.72.208/perkkx/merchantapp'
angular.module 'perkkx.constants', []
.constant 'pxApiEndpoints',
    checkValid: "#{baseUrl}/validate"
    post: "#{baseUrl}/submit"     # Actual Post api
    get: "#{baseUrl}"     # Add pending and all that
    badge: "#{baseUrl}/count"       # add vendor id
    login: "#{baseUrl}/login"
