jQuery(function(){
  $("#short_phone_number").mask("99 99999 9999?");

  var setFormAction = function(){
    var form = $("#sign_up");
    var user_type = form.find("input[name=user_type]:checked").val();
    var action = "/" + user_type + "s";
    form.attr("action", action);

    form.find(".depend-on-type").each(function(i, el){
      var id = el.id;
      $(el).attr("name", user_type + "[" + id + "]");
    });
  }

  var setPhoneNumber = function(){
    var form = $("#sign_up");
    var short_phone_number = form.find("#short_phone_number").val();
    form.find("#phone_number").val("+55 " + short_phone_number);
  }

  $('#sign_up').submit(function(){
    setFormAction();
    setPhoneNumber();
  });
});
