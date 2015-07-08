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
    scrollBack: '=scrollBack'
  compile: (elem, attr) ->
    # attr.defaultPaid = '0' if not attr.defaultPaid
    # attr.defaultDiscount = '0' if not attr.defaultDiscount
    attr.slider = 'true' if not attr.slider
    attr.scrollBack = 'false' if not attr.scrollBack

  controller: ($scope, pxDateCheck, $log, $ionicPopup, $ionicScrollDelegate) ->

    $scope.sliderCheck = () ->
      $scope.slider and pxDateCheck $scope.submitObj.used_on

    $scope.dealOptsCheck = () ->
      $scope.submitObj.hasOwnProperty('dealOpts')

    $scope.data = {
      selectedOpt: {}
    }

    $scope.$watch(
      () -> $scope.submitObj,
      () ->
        if $scope.dealOptsCheck()
          $scope.data.selectedOpt = $scope.submitObj.dealOpts[$scope.submitObj.selectedIndex]
    )

    cleanup = () ->
      $scope.paid = parseInt $scope.defPaid
      $scope.discount = parseInt $scope.defDiscount
      $scope.invalid = false

    cleanup()

    $scope.cancel = () ->
      $scope.formshow = false
      $ionicScrollDelegate.scrollTop() if $scope.scrollBack
      cleanup()

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
      $scope.formshow = false
      $ionicScrollDelegate.scrollTop() if $scope.scrollBack

      res =
        if $scope.invalid
          status: 'expired'
        else
          status: 'used'
          paid: $scope.paid
          discount: $scope.discount

      res.submitted_on = parseInt( Date.now() )
      if $scope.dealOptsCheck()   # extraodinary case
        $log.debug("submitting for bill #{JSON.stringify($scope.data.selectedOpt)}")
        res.used_on = $scope.submitObj.used_on
        # add the correct cID according to the radio button selected
        res.cID = $scope.data.selectedOpt.cID
      else
        $log.debug("no dealOpts")
        res.cID = $scope.submitObj.cID      # Normal cases

      res.orig_cID = $scope.submitObj.cID
      res.rcode = $scope.submitObj.rcode
      res.userID = $scope.submitObj.rcode[0...6]
      cleanup()
      $scope.submitFunc res
  templateUrl: 'directives/bill-form.html'
