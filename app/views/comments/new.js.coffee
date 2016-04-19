jQuery ->
  $('#new_comment').replaceWith "<%= escape_javascript render(partial:'comments/form', object:@comment, as:'comment' ) %>"
