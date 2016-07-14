/* Jquery Script Start
======================================================*/
jQuery(document).ready(function($) {
    "use strict";
	
    /* PrettyPhoto Script
    ======================================================*/
    $('a[data-rel]').each(function () {
        $(this).attr('rel', $(this).data('rel'));
    });
    $('.pretty-gallery a[rel^=\'prettyPhoto\']').prettyPhoto();

    //STICKY HEADER
    if($('.cp_header').length && $('#cp-main-content').length){
      // grab the initial top offset of the navigation
      var stickyNavTop = $('#cp-main-content').offset().top;
      // our function that decides weather the navigation bar should have "fixed" css position or not.
      var stickyNav = function(){
        var scrollTop = $(window).scrollTop(); // our current vertical position from the top
        // if we've scrolled more than the navigation, change its position to fixed to stick to top,
        // otherwise change it back to relative
        if (scrollTop > stickyNavTop) {
          $('.cp_header').addClass('cp_sticky');
        } else {
          $('.cp_header').removeClass('cp_sticky');
        }
      };
      stickyNav();
      // and run it again every time you scroll
      $(window).scroll(function() {
        stickyNav();
      });
    }

    /* Side Bar Menu Js
    ======================================================*/
    if($('#cp_side-menu-btn, #cp-close-btn').length) {

      $(document).on('click', '#cp_side-menu-btn',  function(){

        $('body, #cp_side-menu').animate({
          left: '300px'
        }, 300);
      });
      $(document).on('click', '#cp-close-btn', function(){
        $('body, #cp_side-menu').animate({
          left: '0px'
        }, 300);
      });
    }


    /* Get UTC Offset and Current Time
    ======================================================*/
    $('#utc_offset').val(moment().utcOffset());

    $('.go-to').click(function(event){
      event.preventDefault();
      var now = moment().format('YYYY-MM-DD HH:mm:ss Z');
      $('#now').val(now);
      console.log(now);
      $('.get-location').submit();
    });

	
	/* Owl Slider For Featured Video
    ======================================================*/
	
	if ($('#featured-video').length) {
        $('#featured-video').owlCarousel({
            loop:true,
            dots: false,
            nav:true,
            navText:'',
            items:4,
            autoplay: false,
            smartSpeed:1500,
            margin:30,
            responsive:{
                0:{
                    items:1,
                },
                768:{
                    items:2,
                },
                1199:{
                    items:4,
                }
            }
        });
    }
	
	
	
	
		/* Owl Slider For Featured Video
    ======================================================*/
	if ($('#comedy-videos').length) {
        $('#comedy-videos').owlCarousel({
            loop:true,
            dots: false,
            nav:true,
            navText:'',
            items:3,
            autoplay: false,
            smartSpeed:1500,
            margin:30,
            responsive:{
                0:{
                    items:1,
                },
                768:{
                    items:2,
                },
                1199:{
                    items:3,
                }
            }
        });
    }
	
	
	
	
	/* Owl Slider For Featured Video
    ======================================================*/
	if ($('.today-videos').length) {
	$('.today-videos').bxSlider({
  pagerCustom: '#bx-pager'
});
	}

    /* Owl Slider For Banner
    ======================================================*/
     if ($('#cp_banner-slider').length) {
        $('#cp_banner-slider').owlCarousel({
            loop:true,
            dots: true,
            nav:false,
            navText:'',
            items:1,
            autoplay: true,
            smartSpeed:1000,
        });
    }
	
	
	
	/* Owl Slider For Banner
    ======================================================*/
     if ($('#cp-video-slider').length) {
        $('#cp-video-slider').owlCarousel({
            loop:true,
            dots: true,
            nav:false,
            navText:'',
            items:1,
            autoplay: true,
            smartSpeed:1000,
        });
    }
	

    /* Owl Slider For Upcoming
    ======================================================*/
    if ($('#cp_banner-slider2').length) {
        $('#cp_banner-slider2').owlCarousel({
            loop:true,
            autoplay: true,
            dots: false,
            nav:true,
            navText:'',
            items:2,
            smartSpeed:2000,
            responsiveClass:true,
            responsive:{
                0:{
                    items:1,
                },
                768:{
                    items:2,
                },
                1199:{
                    items:2,
                }
            }
        });
    }

     /* Owl Slider Most Viewed
    ======================================================*/
     if ($('.cp_viewed-slider').length) {
        $('.cp_viewed-slider').owlCarousel({
            loop:true,
            dots: false,
            nav:true,
            navText:'',
            items:1,
            autoplay: true,
            smartSpeed:1500,
        });
    }

    /* Owl Slider For Blog
    ======================================================*/
    if ($('.cp_blog-slider').length) {
        $('.cp_blog-slider').owlCarousel({
            loop:true,
            dots: false,
            nav:false,
            navText:'',
            items:1,
            autoplay: true,
            smartSpeed:2000,
        });
    }


    /* BX Slider For Product Detail
    ======================================================*/
    if ($('#cp_product-slider').length) {
        $('#cp_product-slider').bxSlider({
            auto: true,
            pagerCustom: '#bx-pager',
            navigation: false,
        });
    }


     /* Owl Slider Most Viewed
    ======================================================*/
     if ($('.cp_viewed-slider2').length) {
        $('.cp_viewed-slider2').owlCarousel({
            loop:true,
            dots: false,
            nav:true,
            navText:'',
            items:4,
            autoplay: false,
            smartSpeed:1500,
            margin:30,
            responsiveClass:true,
            responsive:{
                0:{
                    items:1,
                },
                768:{
                    items:2,
                },
                1199:{
                    items:4,
                }
            }
        });
    }

    /* Owl Slider For categories list
    ======================================================*/
    // if ($('.categories-list:not(.medium)').length) {
    //     $('.categories-list:not(.medium)').owlCarousel({
    //         loop:true,
    //         dots: false,
    //         nav:true,
    //         navText:'',
    //         items:4,
    //         autoplay: false,

    //         margin:10,
    //         responsiveClass:true,
    //         responsive:{
    //             0:{
    //                 items:2,
    //             },
    //             768:{
    //                 items:3,
    //             },
    //             1199:{
    //                 items:4,
    //             }
    //         }
    //     });
    // }

    /* Owl Slider For videos list
    ======================================================*/

    $('.owl-carousel').owlCarousel({
        loop:true,
        margin:10,
        responsiveClass:true,
        responsive:{
            0:{
                items:1,
                nav:true
            },
            600:{
                items:3,
                nav:false
            },
            1000:{
                items:5,
                nav:true,
                loop:false
            }
        }
    })
    // if ($('.videos-list').length) {
    //     $('.videos-list').owlCarousel({
    //         loop:true,
    //         dots: false,
    //         nav:true,
    //         navText:'',
    //         items:4,
    //         autoplay: false,

    //         margin:10,
    //         responsiveClass:true,
    //         responsive:{
    //             0:{
    //                 items:2,
    //             },
    //             768:{
    //                 items:3,
    //             },
    //             1199:{
    //                 items:4,
    //             }
    //         }
    //     });
    // }

    /* Audio Player
    ======================================================*/
    if ($('audio').length) {
        $('audio').audioPlayer();
    }

    /* Countdown For Off Countdown
    ======================================================*/
    if($('.cp-off-countdown').length){
        var austDay = new Date();
        austDay = new Date(2016, 3-1, 5,3,15)
        /*$('.cp-off-countdown').countdown({
        labels: ['Years', 'Months', 'Weeks', 'Days', 'Hors', 'Min', 'Sec'],
        until: austDay
        });*/
        $('#year').text(austDay.getFullYear());
    }

    /* Countdown For Coming Countdown
    ======================================================*/
    if($('.cp-coming-countdown').length){
        var austDay = new Date();
        austDay = new Date(2016, 1-1, 5,12,15)
       /* $('.cp-coming-countdown').countdown({
        labels: ['Years', 'Months', 'Weeks', 'Days', 'Hours', 'Min', 'Sec'],
        until: austDay
        });*/
        $('#year').text(austDay.getFullYear());
    }

    
    /* Quantity For Product Detail Pagew
    ======================================================*/
    if ($('.spinnerExample').length) {
        $('.spinnerExample').spinner()
    }

    /* JQuery UI Range Slider For Product
    ======================================================*/
    if ($('#cp-range-slider').length) {
        $( "#cp-range-slider" ).slider({
            range: true,
            min: 0,
            max: 500,
            values: [ 75, 300 ],
            slide: function( event, ui ) {
                $( "#amount" ).val( "$" + ui.values[ 0 ] + " - $" + ui.values[ 1 ] );
            }
        });
        
        $( "#amount" ).val( "$" + $( "#cp-range-slider" ).slider( "values", 0 ) +
        " - $" + $( "#cp-range-slider" ).slider( "values", 1 ) );
    };
    /* Map For Contact Us
    ======================================================*/
    if ($('#cp-map_contact').length) {
        var map;
        var myLatLng = new google.maps.LatLng(48.85661, 2.35222);
        //Initialize MAP
        var myOptions = {
            zoom: 12,
            center: myLatLng,
            //disableDefaultUI: true,
            zoomControl: true,
            mapTypeId: google.maps.MapTypeId.ROADMAP,
            mapTypeControl: false,
            styles: [{
                saturation: -50,
                lightness: 10

            }],
        }
        map = new google.maps.Map(document.getElementById('cp-map_contact'), myOptions);
        //End Initialize MAP
        //Set Marker
        var marker = new google.maps.Marker({
            position: map.getCenter(),
            map: map,
            // icon: 'images/map-icon.png'
        });
        marker.getPosition();
        //End marker

        //Set info window
        //var infowindow = new google.maps.InfoWindow({
            //content: '',
            //position: myLatLng
        //});
        //infowindow.open(map);
    }

    $('#browselink').hover(function () {
        window.setTimeout(function () {
            var dropdown = $("#browsedropdown");
            var offset = dropdown.offset();
            console.log(offset.left + " + " + dropdown.width() + ": " + (offset.left + dropdown.width()));
            if (offset.left + dropdown.width() > $(window).width()) {
                var left = "-" + ((offset.left + dropdown.width()) - $(window).width());
                dropdown.css("left", left + "px");
            }
        }, 751);
    }, function () {
    });

    $('#watchlistlink').hover(function () {
        window.setTimeout(function () {
            var dropdown = $("#watchlistdropdown");
            var offset = dropdown.offset();
            console.log(offset.left + " + " + dropdown.width() + ": " + (offset.left + dropdown.width()));
            if (offset.left + dropdown.width() > $(window).width()) {
                var left = "-" + ((offset.left + dropdown.width()) - $(window).width());
                dropdown.css("left", left + "px");
            }
        }, 751);
    }, function () {
   });

});

/* Set slider items
 ======================================================*/
$(document).ready(function(){

    setSlideItems()
    $(window).resize(function () {
        setSlideItems()
    })

})
var slideItems = 4;

function setSlideItems(){
    var width = $(window).width()
    if(width >= 960){
        slideItems = 4;
    }else if(width >= 768){
        slideItems = 3;
    }else if(width >= 480){
        slideItems = 2;
    }else{
        slideItems = 1;
    }
}
