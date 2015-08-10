angular.module 'perkkx.directives', []
.directive 'pxCoupon', () ->
  restrict: 'E'
  templateUrl: 'directives/coupon.html'
  scope:
    coupon: '=coupon'
    hRedeem: '=redeem'
    hExpiry: '=expiry'
    hBill: '=bill'

.directive 'pxLoginImg', () ->
  restrict: 'E'
  templateUrl: 'directives/loginImg.html'
  scope:
    title: '=title'

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
      pd = $scope.data.paid
      ds = $scope.data.discount
      $log.info "Values for pd and ds : #{pd}, #{ds}"

      errormsg = ""
      patt = /^\d+$/
      if not patt.test(pd) or not patt.test(ds)
        errormsg = "The bill values you entered are invalid: #{pd} and #{ds}"
      else
        paid = parseInt(pd)
        discount = parseInt(ds)
        if paid <= 0 or discount <= 0
          errormsg = "The bill values must be greater than 0"
        else if discount >= paid
          errormsg = "The discount amount should be less than the amount paid"

      #result = 0 < paid > discount > 0
      result = errormsg == ""
      $log.debug "Result: #{result}, Error message: "+errormsg

      $ionicPopup.alert({
        title: 'Unable to submit'
        template: errormsg
        okType: 'button-positive button-small button-clear'
      }) if not result

      result

    $scope.submit = () ->
      $scope.formshow = false
      $ionicScrollDelegate.scrollTop() if $scope.scrollBack

      res =
        paid: parseInt($scope.data.paid)
        discount: parseInt($scope.data.discount)

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
