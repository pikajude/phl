window.mr.droppable = {
  detectDrop: ($scope, event, ui) ->
    $scope.bound = event.target
    $("li.player").unbind "drag"
    $("li.player").on "drag", (event2, ui2) ->
      itemBefore = mr.geometry.lastBefore(ui2.offset.left - $($scope.bound).offset().left, $(event.target).children("div"))
      offs = ui2.offset.left - (if itemBefore.length == 0 then 0 else itemBefore.offset().left)
      if $(event.target).data("team-id") == ui.draggable.data("team-id") && ui.draggable.data("player-id") != itemBefore.data("player-id")
        $(".invalid").removeClass("invalid")
        itemBefore.find("span").css({width: "#{offs}px"})
      else
        itemBefore.addClass("invalid")
  ,

  undetectDrop: ($scope, event, ui, droppingAfterward) ->
    if $scope.bound == event.target
      $("li.player").unbind "drag"
    $(event.target).children("div").each ->
      $(this).find("span").css({width: $(this).data("width") + "px"})
    unless droppingAfterward
      $(event.target).removeClass("invalid")
  ,

  performDrop: ($scope, event, ui) ->
    if $(event.target).data("team-id") == ui.draggable.data("team-id") && $(event.target).find("div.invalid").length == 0
      offset = ui.offset.left - $(event.target).offset().left
      $scope.addSubstitutionAfter(offset, event, ui)
    else
      $(".invalid").removeClass("invalid")
}
