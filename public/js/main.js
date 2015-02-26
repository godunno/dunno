$(document).ready(function() {
  $(".anchorLink").anchorAnimate();
});

jQuery.fn.anchorAnimate = function(settings) {
  settings = jQuery.extend({
    speed : 500
  }, settings);

  return this.each(function(){
    var caller = this;
    $(caller).click(function (event) {
      event.preventDefault();
      var locationHref = window.location.href;
      var elementClick = $(caller).attr("href");

      var destination = $(elementClick).offset().top;
      $("html:not(:animated),body:not(:animated)").animate({ scrollTop: destination}, settings.speed, function() {
        window.location.hash = elementClick;
      });
      return false;
    });
  });
};

var menuOnTop = function() {
  var anc2 = $("#tagline p").offset().top;
  if ($(this).scrollTop()  > anc2) {
    $('#header-menu' ).removeClass('remove-from-top');	
    $('#header-menu' ).addClass('active-on-top');		
  }
  if ($(this).scrollTop() < anc2) {
    $('#header-menu').removeClass('active-on-top');
    $('#header-menu').addClass('remove-from-top');
  }	
};

$(window).scroll(menuOnTop);

$("#subForm").submit(function(event){
  var url = "http://dunno2.createsend.com/t/t/s/kthduy/";

  $.ajax({
    type: 'POST',
    url: url,
    data: $("#subForm").serialize()
  }).always(function(){
    $("#subForm").hide();
    $(".success-message").show();
  });
  event.preventDefault();
});
