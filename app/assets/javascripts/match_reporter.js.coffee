phl = angular.module('phl', ['ngSanitize'])

window.MatchReporter = ($scope) ->
  $scope.game_id = angular.element("#match-reporter").data("game-id")

  $.ajax "/games/#{$scope.game_id}", {
    success: (data, status, xhr) ->
      $scope.game = data
  }

  $.ajax "/games/#{$scope.game_id}/substitutions", {
    success: (data, status, xhr) ->
      $scope.subs = data
      $scope.$apply ->
  }

  $scope.detectDrop = (event, ui) ->
    $scope.bound = event.target
    $("li.player").unbind "drag"
    $("li.player").on "drag", (event2, ui2) ->
      lastBefore = $scope.lastBefore(ui2.offset.left, event)
      offs = ui2.offset.left - (if lastBefore.length == 0 then 0 else lastBefore.offset().left)
      if $(event.target).data("team-id") == ui.draggable.data("team-id") && ui.draggable.data("player-id") != lastBefore.data("player-id")
        $(event.target).removeClass("invalid")
        $(event.target).find("div").each ->
          $(this).find("span").css({width: $(this).data("width") + "px"})
        lastBefore.find("span").css({width: "#{offs}px"})
      else
        $(event.target).addClass("invalid")

  $scope.undetectDrop = (event, ui) ->
    if $scope.bound == event.target
      $("li.player").unbind "drag"
    $(event.target).find("div").each ->
      $(this).find("span").css({width: $(this).data("width") + "px"})
    $(event.target).removeClass("invalid")

  $scope.performDrop = (event, ui) ->
    if $(event.target).data("team-id") == ui.draggable.data("team-id")
      console.log "yay"
      offset = ui.offset.left - $(event.target).offset().left
      $scope.addSubstitutionAfter(offset, event, ui)
    else
      console.log "no"

  $scope.lastBefore = (pos, event) ->
    kids = $.makeArray($(event.target).find("div")).reverse()
    $(_.find kids, (elem) -> $(elem).offset().left < pos)

  $scope.firstAfter = (pos, event) ->
    kids = $.makeArray($(event.target).find("div"))
    $(_.find(kids, (elem) -> $(elem).offset().left > pos) || kids[kids.length - 1])

  $scope.addSubstitutionAfter = (time, event, ui) ->
    prev = $scope.lastBefore(time, event).data("sub-id")
    first = $scope.firstAfter(time, event)
    opts = {
      on_time: if prev then time / 2 else 0,
      off_time: if first.length != 0 then (first.position().left + first.width() - 54) / 2 else 600,
      replaces_id: prev,
      player_id: $(ui.draggable).data("player-id"),
      team_id: $(ui.draggable).data("team-id"),
      gk: $(event.target).data("position") == "gk"
    }
    unless first.data("sub-id") == prev
      opts.replaced_by_id = first.data("sub-id")
    if opts.on_time > opts.off_time
      opts.off_time = 600
    $scope.createSub opts

  $scope.createSub = (obj) ->
    $.ajax "/games/#{$scope.game.id}/substitute", {
      data: {substitution: obj},
      type: "PUT",
      success: (data, status, xhr) ->
        $scope.subs = data
        $scope.$apply ->
    }

  angular.element("li.player").draggable {
    opacity: 0.4,
    revert: true,
    start: -> $(this).addClass("dragging"),
    stop: -> $(this).removeClass("dragging")
  }
  angular.element("ul.positions li.spot").droppable {
    over: $scope.detectDrop,
    out: $scope.undetectDrop,
    drop: (event, ui) ->
      $scope.undetectDrop(event, ui)
      $scope.performDrop(event, ui)
  }

  genColor = (a, b) -> (b ^ a) % 16

  $scope.substitution = (pos, side, idx) ->
    if $scope.subs
      $("ul.positions li").css({width: "#{$scope.game.length * 2}px"})
      return if !$scope.subs[side] || !$scope.subs[side][pos] || !$scope.subs[side][pos][idx]
      subs = $scope.subs[side][pos][idx]
      ("""
      <div data-player-id='#{sub.player.id}' data-sub-id='#{sub.id}' class='sub-color-#{genColor(side, sub.player.id)}' style='width: #{(sub.off_time - sub.on_time) * 2}px' data-width='#{(sub.off_time - sub.on_time) * 2}'>
        <span style='width: #{(sub.off_time - sub.on_time) * 2}px'>
          #{sub.player.username} 
        </span>
      </div>
      """ for sub in subs).join ""
    else
      ""
