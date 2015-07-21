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
    scrollBack: '=scrollBack'
  compile: (elem, attr) ->
    # attr.defaultPaid = '0' if not attr.defaultPaid
    # attr.defaultDiscount = '0' if not attr.defaultDiscount
    attr.scrollBack = 'false' if not attr.scrollBack

  controller: ($scope, $log, $ionicPopup, $ionicScrollDelegate) ->

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
      $scope.data.paid = parseInt $scope.defPaid
      $scope.data.discount = parseInt $scope.defDiscount

    cleanup()

    $scope.cancel = () ->
      $scope.formshow = false
      $ionicScrollDelegate.scrollTop() if $scope.scrollBack
      cleanup()

    $scope.validate = () ->
        result = $scope.data.paid > 0 and $scope.data.discount > 0

        $ionicPopup.alert({
          title: 'Unable to submit'
          template: "The bill values you entered are invalid: #{$scope.data.paid} and #{$scope.data.discount}"
          okType: 'button-positive button-small button-clear'
        }) if not result

        result

    $scope.submit = () ->
      $scope.formshow = false
      $ionicScrollDelegate.scrollTop() if $scope.scrollBack

      res =
        paid: parseInt($scope.data.paid)
        discount: parseInt($scope.data.discount)

      res.submitted_on = parseInt( Date.now() )
      if $scope.dealOptsCheck()   # extraodinary case
        res.used_on = $scope.submitObj.used_on
        res.cID = $scope.data.selectedOpt.cID       # add the correct cID according to the radio button selected
      else
        res.cID = $scope.submitObj.cID      # Normal cases

      if $scope.submitObj.hasOwnProperty('cID')
        res.orig_cID = $scope.submitObj.cID
      res.rcode = $scope.submitObj.rcode
      res.userID = $scope.submitObj.rcode[0...6]

      cleanup()
      $scope.submitFunc res
  templateUrl: 'directives/bill-form.html'
