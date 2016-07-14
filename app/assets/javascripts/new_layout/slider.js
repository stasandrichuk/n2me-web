
function Slider(options) {
  if( typeof(options) === 'undefined' ){
    options = {next: true, prev: true}
  }
  this.options = options
  this.bindEvents()
}
Slider.prototype.bindEvents = function () {
  if(this.options.next){
    $('.previous').click(function(){
      var container = $(this).parent().find('.row__inner')
      var itemWidth = container.find('.tile').first().width()
      var left = container.offset().left + (itemWidth+14) *4 ;
      if(left > 5){
        left = 5;
      }
      container.animate( { left: left }, 200)
      return false;
    })
  }
  if(this.options.prev){
    $('.next').click(function(){
      var container = $(this).parent().find('.row__inner')
      var itemWidth = container.find('.tile').first().width()
      var maxWidth = container[0].scrollWidth;
      if(maxWidth > container.parents('.uk-slidenav-position').width()){
        var left = $(this).parent().find('.row__inner').offset().left-(itemWidth+14)*4 ;
        if(Math.abs(left) > (maxWidth- container.parents('.uk-slidenav-position').width())){
          left =  -(maxWidth - container.parents('.uk-slidenav-position').width());
        }
        container.animate( {left: left}, 200)
      }
      return false;
    })
  }
  var x,y,top,left,down, stuff;

  $(".row__inner").mousedown(function(e){
      e.preventDefault();
      down=true;
      x=e.pageX;
      y=e.pageY;
      left=$(this).offset().left;
      stuff = $(this)
  });

  $("body").mousemove(function(e){
      var newX=e.pageX;
      var newY=e.pageY;
      var _left;
      if(down){
        if(newX > x){
          _left = left + newX -x + 100;
          if( _left > 5) _left = 5;
        }else{
          _left = left - (x - newX) -100;
          var maxWidth = stuff[0].scrollWidth;
          if(Math.abs(_left) > (maxWidth- $(window).width())){
            _left =  -(maxWidth - $(window).width());
          }
        }
        stuff.css({left: _left});
      }
  });
  $("body").mouseup(function(e){down=false;});

}