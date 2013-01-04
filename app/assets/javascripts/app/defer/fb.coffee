`window.fbAsyncInit = function() {
  FB.init({
    appId      : '283811231688828', // App ID
    channelUrl : '//1kpl.us/channel.html', // Channel File
    status     : true, // check login status
    cookie     : true, // enable cookies to allow the server to access the session
    xfbml      : true  // parse XFBML
  });

  // Additional initialization code here
};

// Load the SDK Asynchronously
(function(d){
   var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
   if (d.getElementById(id)) {return;}
   js = d.createElement('script'); js.id = id; js.async = true;
   js.src = "//connect.facebook.net/en_US/all.js";
   ref.parentNode.insertBefore(js, ref);
 }(document));`


App.fbPost = (name, link) ->
  options =
    method: "feed"
    name: name
    link: link

#  responder = (response) ->
#    if response? and response.post_id
#    else
  FB.ui(options, responder)

$(document).on 'click', '.fb-post', (evt) ->
  id = $(evt.target).closest(".item").parent().attr("data-id")
  item = App.items.get(id)
  _title = item.get("title")
  _link = item.get("url")
  App.fbPost(_title, _link)
  return false

