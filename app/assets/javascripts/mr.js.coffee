phl = angular.module('phl', ['ngSanitize'])

window.mr ||= {}

window.MatchReporter = ($scope) ->
  $scope.getBounds = (ui, p) ->
    before = _.find p.children().slice().toArray().reverse(), (e) ->
      $(e).position().left < (ui.offset.left - p.offset().left)
    after = _.find p.children().toArray(), (e) ->
      $(e).position().left > (ui.offset.left - p.offset().left)
    offset = Math.max(0, Math.round((ui.offset.left - p.offset().left) / 3))
    minutes = Math.floor(offset / 60)
    seconds = offset % 60
    format = if seconds < 10 then "0" + seconds else ("" + seconds)
    {
      before: before,
      after: after,
      start: minutes * 60 + seconds,
      end: if after then Math.floor($(after).position().left / 3) else 300,
      formatted: minutes + ":" + format + " - 5:00"
    }

  $scope.substitute = (obj) ->
    $.ajax("/games/#{$scope.gameId}/substitute", {
      dataType: "json",
      data: { substitution: obj }
      type: "POST",
      success: (data, status, xhr) ->
        $scope.substitutions = data
        $scope.$apply ->
    })

  # droppable doesn't trigger drag events itself, so we
  # have to combine the two :3
  $scope.startDragging = (elem, p) ->
    if $scope.validate(elem, p)
      $(elem).tipsy({trigger: "manual", gravity: $.fn.tipsy.autoNS})
      $(elem).on "drag", (event, ui) ->
        console.log($scope.getBounds(ui, p))
        $(elem).attr("title", $scope.getBounds(ui, p).formatted)
        $(elem).tipsy("show")
    else
      p.addClass("invalid")

  $scope.stopDragging = (elem, p) ->
    $(elem).tipsy("hide")
    $("li.player").unbind "drag"
    p.removeClass("invalid")

  $scope.validate = (elem, p) -> $(elem).data("team-id") == p.data("team-id")

  $scope.drop = (elem, p, ui) ->
    if p.hasClass("invalid")
      p.removeClass("invalid")
      return
    $(elem).tipsy("hide")
    $("li.player").unbind "drag"
    bounds = $scope.getBounds(ui, p)
    args = {
      on_time: bounds.start,
      off_time: bounds.end,
      player_id: $(elem).data("player-id"),
      team_id: $(elem).data("team-id"),
      gk: p.data("position") == "gk",
      half: $scope.currentHalf
    }
    if bounds.after
      args.replaced_by_id = $(bounds.after).data("sub-id")
    $scope.substitute(args)

  angular.element("li.player").draggable {
    opacity: 0.4,
    revert: true,
    grid: [3, 1],
    revertDuration: 100,
    cursorAt: { left: 5, top: 10 },
    start: -> $(this).addClass("dragging")
    stop: -> $(this).removeClass("dragging")
  }

  angular.element("li.spot").droppable {
    tolerance: "pointer",
    over: (event, ui) ->
      self = $(this)
      self.addClass("hover")
      $scope.startDragging(ui.draggable[0], self)
    out:  (event, ui) ->
      self = $(this)
      self.removeClass("hover")
      $scope.stopDragging(ui.draggable[0], self)
    drop: (event, ui) ->
      self = $(this)
      self.removeClass("hover")
      $scope.drop(ui.draggable[0], self, ui)
  }

  $scope.gameId = $("#match-reporter").data("game-id")
  $scope.currentHalf = 1

  $.ajax("/games/#{$scope.gameId}", {
    success: (data, status, xhr) ->
      $scope.game = data
  })

  $.ajax("/games/#{$scope.gameId}/substitutions/#{$scope.currentHalf}", {
    dataType: "json",
    success: (data, status, xhr) ->
      $scope.substitutions = data
      $scope.$apply ->
  })

  $scope.substitution = (pos, side, idx) ->
    genColor = (a, b) -> (b ^ a) % 12
    if $scope.substitutions
      return if !$scope.substitutions[side] || !$scope.substitutions[side][pos] || !$scope.substitutions[side][pos][idx]
      subs = $scope.substitutions[side][pos][idx]
      ("""
      <div data-player-id='#{sub.player.id}' data-sub-id='#{sub.id}' class='sub-color-#{genColor(side, sub.player.id)} substitution' style='width: #{(sub.off_time - sub.on_time) * 3}px; left: #{sub.on_time * 3}px' data-width='#{(sub.off_time - sub.on_time) * 3}'>
        <span style='width: #{(sub.off_time - sub.on_time) * 3}px'>
          #{sub.player.username}
        </span>
      </div>
      """ for sub in subs).join ""
    else
      ""
