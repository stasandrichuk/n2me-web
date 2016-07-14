jQuery(document).ready(function(){
  if(!$('.nav-tabs').length){
    return;
  }
  $('.nav-tabs a').click(function(e){
    e.preventDefault();
    $(this).tab('show');
    return false;
  });

  var hash = document.location.hash;
  if (hash != '' && $(hash).length){
    $('[href="' + hash + '"]').tab('show');
  }

});

function Avatar(options) {
  this.user = options.user
  this.container = $('.user_heading_avatar')
  this.bindEvents()

}

Avatar.prototype.bindEvents = function () {
  var self = this;

  // Avoid ul exit on li click
  $(document).on('click','.user_heading_avatar ul.dropdown-menu li', function (){
    return false
  })

  $('.user_heading_avatar ul.dropdown-menu li.item a').click(function(){
    var $el = $(this)
    var data = {
      id: self.user.id, 
      user: { avatar_option: $(this).data('avatar-option') }
    };
    $.ajax({
      type: "PUT", url: '/users', data: data, dataType: 'json',
      success: function(){
        $el.parents('ul').find('li.item a').removeClass('selected')
        $el.addClass('selected')
        self.container.find('img.avatar').attr('src', $el.find('img').attr('src'))
        self.user.avatar_option = data.user.avatar_option
      }
    });
  })

  self.container.find('button.close').click(function(){
    self.container.find(".dropdown-toggle").dropdown("toggle");
  })

  self.container.find('li.upload input').change(function(){
    $.ajax({
      url: '/users/update_avatar',
      data: {id: self.user.id},
      files: $(this), iframe: true
    }).complete(function(data) {
      var json = data.responseJSON;
      console.log(json)
      if(json.url){
        self.container.find('li.uploaded-picture').removeClass('hidden').find('img').attr('src', json.url)
        if(self.user.avatar_option.toString() == "2"){
          self.container.find('img.avatar').attr('src', json.url)
        }
      }
    });
  })
}