window.mr.geometry = {
  leftOffset: 55,

  lastBefore: (bound, selector) ->
    kids = $.makeArray($(selector)).reverse()
    $(_.find(kids, (elem) -> $(elem).position().left - mr.geometry.leftOffset < bound) || kids[0])
  ,

  firstAfter: (bound, selector) ->
    kids = $.makeArray($(selector))
    $(_.find(kids, (elem) -> $(elem).position().left + mr.geometry.leftOffset > bound) || kids[kids.length - 1])
}
