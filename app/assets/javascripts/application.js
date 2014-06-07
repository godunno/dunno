// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require js/bootstrap.min.js
//= require js/jquery.dcjqaccordion.2.7.js
//= require js/jquery.scrollTo.min.js
//= require js/jquery.nicescroll.js
//= require js/jquery.sparkline.js
//= require js/common-scripts.js
//= require js/owl.carousel.js
//= require assets/bootstrap-datetimepicker/js/bootstrap-datetimepicker.min.js
//= require assets/bootstrap-datetimepicker/js/locales/bootstrap-datetimepicker.pt-BR.js
//= require assets/bootstrap-timepicker/js/bootstrap-timepicker.js
//= require assets/bootstrap-datepicker/js/bootstrap-datepicker.js
//= require angular
//= require angular-route
//= require angular-resource
//= require angularjs-rails-resource
//= require_tree ./angular/
//= require inputs.js

function ready() {

  /* Form: Focus and Hint */

	$('input[type="text"], input[type="password"], textarea').focus(function() {
    $(this).parent().find('.hint').show();
		$(this).css("box-shadow", "#ccc 0 0 5px");
	});
	$('input[type="text"], input[type="password"], textarea').blur(function() {
    $(this).parent().find('.hint').hide();
		$(this).css("box-shadow", "none");
	});

}

$(document).ready(ready);
$(document).on('page:load', ready);
