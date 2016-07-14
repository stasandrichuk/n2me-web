function Cart(options) {
  this.products = options.products
  this.userAgent = options.userAgent
  this.selectedProducts = options.selectedProducts
  this.items =  {}
  this.bindEvents()
}

Cart.prototype.bindEvents = function () {
  var self = this
  $('.pricing input.checkbox:checked').attr('checked', false)
  $('.pricing input.checkbox').click(function(){
    var flag = $(this).is(':checked')
    var productId = $(this).data('product')
    if(flag){
      if (typeof(self.items[productId]) === 'undefined'){
        self.items[productId] = self.products[productId]
        self.addItem(productId, self.items[productId])
      }
    }else{
      delete self.items[productId]
      self.deleteItem(productId)
    }
  })

  $('.cart-items .btn-cart-checkout').click(function(){
    if(!$.isEmptyObject(self.items)){
      var productIds = []
      $.each(self.items, function(productId){
        productIds[productIds.length] = productId
      })
      window.location.href = '/subscriptions/new?product_ids=' + productIds.join(',')
    }else{
      alert('Please add a package to your cart.')
    }
    return false;
  })

  $('.cart-item .btn-subcribe').click(function(){
    var input = $(this).parents('.buttons').find('input.checkbox');
    if(!input.is(':checked')){
      input.click()
    }
  })

  if(self.userAgent === 'desktop'){
    $(window).unbind("scroll").scroll(function (e) {
      if($(document).width() >= 993){
        var top = $(window).scrollTop()
        if ( top <= 125){
          top = 0;
        }else{
          top = top - 150;
        }
        var maxTop = $(document).height() - $('footer').height() - $('.cart-items').height() -180
        if((top) >= maxTop){
          top = maxTop;
        };
        $('.cart-items').css({top: top+"px"})
      }else{
        $('.cart-items').css({top: "0px"})
      }
    })
  }

  $.each(this.selectedProducts, function(i, productId){
    console.log(productId)
    $(".btn[data-product='" +productId+ "']").click()
  })

}

Cart.prototype.addItem = function (productId, productDetails) {
  var html = '<tr class="cart-item-' + productId + '">'
  html += '<th>'
  html += productDetails.title
  html += '</th>'
  html += '<td>'
  html += '$' +productDetails.price
  html += '</td>'
  html += '</tr>'
  var subTotalEl = $('.cart-items .cart-total')
  $(html).insertBefore(subTotalEl)
  subTotalEl.find('.amount').text('$' + this.subTotal().toFixed(2))
}

Cart.prototype.deleteItem = function(productId){
  $('.cart-items .cart-item-' +productId).remove()
  $('.cart-items .cart-total .amount').text('$' + this.subTotal())
};

Cart.prototype.subTotal = function(){
  var subTotal = 0.00
  $.each(this.items, function(productId, details){
    subTotal = subTotal + details.price
  })
  return subTotal
}
