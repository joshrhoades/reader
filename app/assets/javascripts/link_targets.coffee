$(document).on "click", ".item a", (evt) ->
  $(evt.target).attr("target", "_blank")
