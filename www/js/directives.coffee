angular.module 'perkkx.directives', []
.directive 'pxCoupon', () ->
  restrict: 'E'
  templateUrl: 'directives/coupon.html'
  scope:
    coupon: '=coupon'
    hRedeem: '=redeem'
    hExpiry: '=expiry'
    hBill: '=bill'

.directive 'pxBillForm', (pxDateCheck) ->
  restrict: 'E'
  scope:
    submitFunc: '=submitFunc'
    formshow: '=show'
    submitObj: '=submitObj'
    defPaid: '=defaultPaid'
    defDiscount: '=defaultDiscount'
    slider: '=slider'
  compile: (elem, attr) ->
    # attr.defaultPaid = '0' if not attr.defaultPaid
    # attr.defaultDiscount = '0' if not attr.defaultDiscount
    attr.slider = 'true' if not attr.slider
  controller: ($scope, pxDateCheck) ->
    $scope.sliderCheck = () ->
      $scope.slider and pxDateCheck $scope.submitObj.used_on
    cleanup = () ->
      $scope.paid = parseInt $scope.defPaid
      $scope.discount = parseInt $scope.defDiscount
      $scope.invalid = false
    cleanup()

    $scope.cancel = () ->
      cleanup()
      $scope.formshow = false

    $scope.validate = () ->
        $scope.invalid or
          ($scope.paid > 0 and $scope.discount > 0)
    $scope.submit = () ->
      res =
        if $scope.invalid
          status: 'expired'
        else
          status: 'used'
          paid: $scope.paid
          discount: $scope.discount

      res.submitted_on = parseInt( Date.now() / 1000 )
      res.cID = $scope.submitObj.cID
      res.rcode = $scope.submitObj.rcode
      res.userID = $scope.submitObj.userID
      $scope.submitFunc res
  templateUrl: 'directives/bill-form.html'
