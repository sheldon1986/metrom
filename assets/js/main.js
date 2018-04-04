
(function ($) {
  "use strict";
	new WOW().init();
  /* 네비게이션 스크롤 제어 */
  jQuery(document).ready(function($){
    $(".navbar-toggle").click(function() {
        $(this).toggleClass("open"), $(".inner-body").toggleClass("move"), $("body").toggleClass("no-overflow")
    });
    // Header Scroll
  	$(window).on('scroll', function() {
  		var scroll = $(window).scrollTop();
  		if (scroll >= 50) {
  			$('#home').addClass('fixed');
  		} else {
  			$('#home').removeClass('fixed');
  		}
  	});
  });
})(jQuery);
