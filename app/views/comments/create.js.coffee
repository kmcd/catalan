jQuery ->
  $('.comments').append "<%= escape_javascript render(partial:'comments/show', object:@comment, as:'comment' ) %>"
  
  $('#new_comment').replaceWith "<%= escape_javascript render(partial:'comments/form', object:@article.comments.new, as:'comment' ) %>"
