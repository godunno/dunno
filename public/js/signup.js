jQuery(function(){
  $("#short_phone_number").mask("99 99999 9999?");

  var setPhoneNumber = function(){
    var form = $("#sign_up");
    var short_phone_number = form.find("#short_phone_number").val();
    form.find("#phone_number").val("+55 " + short_phone_number);
  }

  $('#sign_up').submit(function(){
    setPhoneNumber();
  });
});
