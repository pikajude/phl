phl = angular.module('phl', ['ngSanitize'])

window.mr ||= {}

$.fn.right = -> $(this).position().left + $(this).width()

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
      $scope.bindResizes()
  }

  $scope.addSubstitutionAfter = (time, event, ui) ->
    prev = mr.geometry.lastBefore(time, $(event.target).children("div")).data("sub-id")
    first = mr.geometry.firstAfter(time, $(event.target).children("div"))
    opts = {
      on_time: if prev then time / 2 else 0,
      off_time: if first.length != 0 then (first.position().left - 54) / 2 else 600,
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
        $scope.bindResizes()
    }

  angular.element("li.player").draggable {
    opacity: 0.4,
    revert: true,
    revertDuration: 100,
    start: ->
      $(this).addClass("dragging")
      $("div[data-player-id=#{$(this).data("player-id")}] .ui-resizable").resizable("option", "disabled", true)
    ,
    stop: ->
      $(this).removeClass("dragging")
      $(".ui-resizable").resizable("option", "disabled", false)
  }
  angular.element("ul.positions li.spot").droppable {
    over: (event, ui) -> mr.droppable.detectDrop($scope, event, ui),
    out:  (event, ui) -> mr.droppable.undetectDrop($scope, event, ui),
    drop: (event, ui) ->
      mr.droppable.undetectDrop($scope, event, ui, true)
      mr.droppable.performDrop($scope, event, ui)
  }

  $scope.bindResizes = ->
    _.each angular.element("li.spot span"), (e) ->
      $(e).resizable {
        handles: "e, w",
        stop: (event, ui) -> $scope.updateSingle(event),
        start: $scope.restrictBounds
      }

  $scope.restrictBounds = (event, ui) ->
    if $(event.toElement).hasClass("ui-resizable-w")
      $target = $(event.target)
      kids = $.makeArray($target.parents("li").children("div")).reverse()
      first = $(_.find kids, (elem) -> $(elem).right() - 55 < ui.originalPosition.left)
      difference = $target.parent("div").position().left - first.right()
      $target.resizable("option", "maxWidth", $target.width() + difference)
    else
      console.log("lol not handled yet")

  $scope.updateSingle = (event) ->
    span = $(event.target)
    parent = span.parent("div")
    opts = {
      on_time: (span.position().left + parent.position().left) / 2,
      off_time: (span.right() + parent.position().left) / 2 + 10,
      id: parent.data("sub-id")
    }
    $.ajax "/games/#{$scope.game.id}/substitution", {
      data: { substitution: opts },
      type: "PUT",
      success: (data, status, xhr) ->
        sub = $("div[data-sub-id=#{data.id}]")
        sub.children("span").css("left", "")
        sub.css({
          width: "#{(data.off_time - data.on_time) * 2}px",
          left: "#{data.on_time * 2}px"
        })
    }

  genColor = (a, b) -> (b ^ a) % 12

  $scope.substitution = (pos, side, idx) ->
    if $scope.subs
      $("ul.positions li").css({width: "#{$scope.game.length * 2}px"})
      return if !$scope.subs[side] || !$scope.subs[side][pos] || !$scope.subs[side][pos][idx]
      subs = $scope.subs[side][pos][idx]
      ("""
      <div data-player-id='#{sub.player.id}' data-sub-id='#{sub.id}' class='sub-color-#{genColor(side, sub.player.id)} substitution' style='width: #{(sub.off_time - sub.on_time) * 2}px; left: #{sub.on_time * 2}px' data-width='#{(sub.off_time - sub.on_time) * 2}'>
        <span style='width: #{(sub.off_time - sub.on_time) * 2}px'>
          #{sub.player.username} 
        </span>
      </div>
      """ for sub in subs).join ""
    else
      ""

  angular.element("ul.positions").on "scroll", (evt) ->
    offs = evt.target.scrollLeft
    $("li.spot span").each ->
      $(this).css {
        "padding-left": Math.max(5, 104 - $(this).offset().left)
      }
