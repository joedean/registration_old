$.fn.add_fields = (link_id, association, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp("new_" + association, "g")
  $(link_id).before(content.replace(regexp, new_id))

$ ->
  $(".fields").on "click", ".remove-link", ->
    console.log "inside click"
    $(this).prev("input[type=hidden]").val("1")
    $(this).closest(".fields").hide()
