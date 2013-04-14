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
    self = event.target
    pos = $(event.target).position()
    $("li.player").unbind "drag"
    $("li.player").on "drag", (event2, ui2) ->
      offs = ui2.offset.left - pos.left - 16
      $(event.target).find("div:first-child").css({width: "#{offs}px"})

  $scope.undetectDrop = (event, ui) ->
    if $scope.bound == event.target
      $("li.player").unbind "drag"
    $(event.target).find("div:first-child").css({width: "100%"})

  $scope.performDrop = (event, ui) ->
    offset = ui.offset.left - $(event.target).position().left - 16
    fullsize = $(event.target).width()
    alert(offset / fullsize)

  angular.element("li.player").draggable {
    opacity: 0.4,
    revert: true,
    start: -> $(this).addClass("dragging"),
    stop: -> $(this).removeClass("dragging")
  }
  angular.element("#match-reporter li").droppable {
    over: $scope.detectDrop,
    out: $scope.undetectDrop,
    drop: (event, ui) ->
      $scope.undetectDrop(event, ui)
      $scope.performDrop(event, ui)
  }

  genColor = (a, b) -> (b ^ a) % 16

  $scope.substitution = (pos, side, idx) ->
    if $scope.subs
      subs = $scope.subs[side][pos][idx]
      ("""
      <div class='sub-color-#{genColor(side, sub.player.id)}' style='width: #{(sub.off_time - sub.on_time) / $scope.game.length * 100}%'>
          #{sub.player.username} 
        </div>
      """ for sub in subs).join ""
    else
      ""
