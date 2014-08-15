
/* Author: Fabiano Meneghetti
*/
		
 
	/* Slide to anchors */
	$(document).ready(function() {
		$(".form-signup input:text").eq(0).focus();
		$(".anchorLink").anchorAnimate();
		$(".fancybox").fancybox();
		$(".various").fancybox({
			maxWidth    : 800,
			fitToView	: false,
			width		: '100%',
			autoSize	: false,
			closeClick	: false,
			openEffect	: 'none',
			closeEffect	: 'none',
			padding     : '0',
			scrolling   : 'no',
		});
	});
	
	
		
	jQuery.fn.anchorAnimate = function(settings) {
	       settings = jQuery.extend({
	               speed : 500
	               }, settings);        

	               return this.each(function(){
	                       var caller = this
	                       $(caller).click(function (event) {        
	                               event.preventDefault()
	                               var locationHref = window.location.href
	                               var elementClick = $(caller).attr("href")

	                               var destination = $(elementClick).offset().top;
	                               $("html:not(:animated),body:not(:animated)").animate({ scrollTop: destination}, settings.speed, function() {
	                                       window.location.hash = elementClick
	                               });
	                               return false;
	                       })
	               })
	       }
	

	// Classe no menu para ficar fixo no topo
		$( window ).scroll( function() {
			var anc2 = $("#tagline p").offset().top;
			if( $( this ).scrollTop()  > anc2) {
				$( '#header-menu' ).removeClass( 'remove-from-top' );	
				$( '#header-menu' ).addClass( 'active-on-top' );		
			}
			if( $( this ).scrollTop() < anc2) {
				$( '#header-menu' ).removeClass( 'active-on-top' );
				$( '#header-menu' ).addClass( 'remove-from-top' );
			}	
		});
		
		$('.bt-call-small-dark').click(function() {
			$('.bt-call-small-dark').addClass('hide-bt');
			$('.mail-field').addClass('show-field');
			 return false;
		});
		