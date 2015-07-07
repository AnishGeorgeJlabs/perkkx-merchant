angular.module 'perkkx.directives', []
.directive 'pxCoupon', () ->
  restrict: 'E'
  templateUrl: 'directives/coupon.html'
  scope:
    coupon: '=coupon'
    hRedeem: '=redeem'
    hExpiry: '=expiry'
    hBill: '=bill'

.directive 'pxBillForm', () ->
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

  controller: ($scope, pxDateCheck, $log, $ionicPopup, $cordovaToast) ->

    $scope.sliderCheck = () ->
      $scope.slider and pxDateCheck $scope.submitObj.used_on

    $scope.dealOptsCheck = () ->
      $scope.submitObj.hasOwnProperty('dealOpts')

    $scope.selectedOpt = {}

    $scope.$watch(
      () -> $scope.submitObj,
      () ->
        if $scope.dealOptsCheck()
          $scope.selectedOpt = $scope.submitObj.dealOpts[0]
    )

    cleanup = () ->
      $scope.paid = parseInt $scope.defPaid
      $scope.discount = parseInt $scope.defDiscount
      $scope.invalid = false

    cleanup()

    $scope.cancel = () ->
      cleanup()
      $scope.formshow = false

    $scope.validate = () ->
        result = $scope.invalid or
          ($scope.paid > 0 and $scope.discount > 0)

        $ionicPopup.alert({
          title: 'Unable to submit'
          template: 'The bill values you entered are invalid'
          okType: 'button-positive button-small button-clear'
        }) if not result

        result

    $scope.submit = () ->
      res =
        if $scope.invalid
          status: 'expired'
        else
          status: 'used'
          paid: $scope.paid
          discount: $scope.discount

      res.submitted_on = parseInt( Date.now() )
      if $scope.dealOptsCheck()   # extraodinary case
        res.used_on = $scope.submitObj.used_on
        # add the correct cID according to the radio button selected
        res.cID = $scope.selectedOpt.cID
      else
        res.cID = $scope.submitObj.cID      # Normal cases

      res.rcode = $scope.submitObj.rcode
      res.userID = $scope.submitObj.userID
      cleanup()
      $scope.submitFunc res
  templateUrl: 'directives/bill-form.html'
