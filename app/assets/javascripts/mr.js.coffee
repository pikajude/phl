phl = angular.module('phl', ['ngSanitize'])

window.MatchReporter = ($scope) ->
  $scope.render = (data) ->
    $scope.substitutions = data
    $scope.$apply ->

    $(".tipsy").remove()
    $("a.kill-sub").tipsy({gravity: 's'}).click (e) ->
      e.preventDefault()
      sub = $(this).parent().parent()
      $.ajax("/games/#{$scope.gameId}/substitution/delete", {
        type: "POST",
        data: {
          substitution: {
            id: sub.data("sub-id"),
            half: $scope.currentHalf
          }
        },
        success: $scope.render
      })

    angular.element("li.spot div.substitution").resizable {
      handles: "e, w",
      grid: [3, 1],
      start: (event, ui) ->
        leftSide = $(this).css("cursor").match(/w-/)
        $(this).tipsy {
          trigger: "manual",
          gravity: if leftSide then 'e' else 'w'
        }
        m = $scope.getBounds(ui, $(event.target).parent(), true)
        if leftSide
          $(this).resizable("option", "maxWidth", $(this).width() + ($(this).position().left - (m.leftBound * 3)))
        else
          $(this).resizable("option", "maxWidth", (m.rightBound * 3) - $(this).position().left)
      ,
      stop: (event, ui) ->
        $(this).tipsy("hide").resizable("option", "maxWidth", null)
        $scope.updateSubstitution($(event.target))
      ,
      resize: (event, ui) ->
        leftSide = $(this).css("cursor").match(/w-/)
        if leftSide
          $(this).attr("title", $scope.getBounds(ui, $(event.target).parent(), true).formatted.split(" ")[0])
                 .tipsy("show")
        else
          $(this).attr("title", $scope.getBounds(ui, $(event.target).parent(), true).formatted.split(" ")[2])
                 .tipsy("show")
    }

  # some library function stuff
  $scope.getBounds = (ui, p, magicFlag) ->
    format = (s) ->
      r = s % 60
      Math.floor(s / 60) + ":" + (if r < 10 then "0" else "") + r
    if ui.offset
      thing = ui.offset.left - p.offset().left
    else
      thing = ui.position.left

    before = _.find p.children().slice().toArray().reverse(), (e) ->
      $(e).position().left < thing
    after = _.find p.children().toArray(), (e) ->
      $(e).position().left > thing

    offset = Math.max 0, Math.round(thing / 3)

    a = {
      before: before,
      after: after,
      start: offset,
      end: if ui.offset then ui.offset.left else ui.position.left + ui.size.width,
      leftBound: if before then Math.floor(($(before).position().left + $(before).width()) / 3) else 0,
      rightBound: if after then Math.floor($(after).position().left / 3) else 300,
    }

    a.formatted = format(a.start or 0) + " - " + (if magicFlag then format(a.end / 3) else format(a.rightBound))
    console.log(a)

    a

  $scope.substitution = (pos, side, idx) ->
    genColor = (a, b) -> (b ^ a) % 12
    if $scope.substitutions
      return if !$scope.substitutions[side] || !$scope.substitutions[side][pos] || !$scope.substitutions[side][pos][idx]
      subs = $scope.substitutions[side][pos][idx]
      ("""
      <div data-player-id='#{sub.player.id}' data-sub-id='#{sub.id}' class='sub-color-#{genColor(side, sub.player.id)} substitution' style='width: #{(sub.off_time - sub.on_time) * 3}px; left: #{sub.on_time * 3}px' data-width='#{(sub.off_time - sub.on_time) * 3}'>
        <span style='display: block'>
          <a href='#' class='kill-sub' title='Remove this player'>×</a>
          #{sub.player.username}
        </span>
      </div>
      """ for sub in subs).join ""
    else
      ""

  $scope.substitute = (obj) ->
    $.ajax "/games/#{$scope.gameId}/substitute", {
      data: { substitution: obj }
      type: "POST",
      success: $scope.render
    }

  $scope.updateSubstitution = (ev) ->
    $.ajax "/games/#{$scope.gameId}/substitution", {
      type: "POST",
      data: {
        substitution: {
          id: ev.data("sub-id"),
          on_time: ev.position().left / 3,
          off_time: (ev.position().left + ev.width()) / 3
        }
      }
    }

  # event stuff
  #
  # droppable doesn't trigger drag events itself, so we
  # have to combine the two :3
  $scope.startDragging = (elem, p) ->
    if $scope.validate elem, p
      $(elem).tipsy {
        trigger: "manual",
        gravity: $.fn.tipsy.autoNS
      }
      $(elem).on "drag", (event, ui) ->
        $(elem).attr "title", $scope.getBounds(ui, p).formatted
        $(elem).tipsy "show"
    else
      p.addClass "invalid"

  $scope.stopDragging = (elem, p) ->
    $(elem).tipsy "hide"
    $("li.player").unbind "drag"
    p.removeClass "invalid"

  $scope.validate = (elem, p) -> $(elem).data("team-id") == p.data("team-id")

  $scope.drop = (elem, p, ui) ->
    if p.hasClass "invalid"
      p.removeClass "invalid"
      return
    $(elem).tipsy "hide"
    $("li.player").unbind "drag"
    bounds = $scope.getBounds(ui, p)
    args = {
      on_time: bounds.start,
      off_time: bounds.rightBound,
      player_id: $(elem).data("player-id"),
      team_id: $(elem).data("team-id"),
      gk: p.data("position") == "gk",
      half: $scope.currentHalf
    }
    if bounds.before
      args.replaces_id = $(bounds.before).data "sub-id"
    if bounds.after
      args.replaced_by_id = $(bounds.after).data "sub-id"
    $scope.substitute args


  # bindings lol
  angular.element("li.player").draggable {
    opacity: 0.4,
    revert: true,
    grid: [3, 1],
    revertDuration: 100,
    cursorAt: { left: 5, top: 10 },
    start: -> $(this).addClass "dragging"
    stop: -> $(this).removeClass "dragging"
  }

  angular.element("li.spot").droppable {
    tolerance: "pointer",
    over: (event, ui) ->
      self = $(this)
      self.addClass("hover")
      $scope.startDragging ui.draggable[0], self
    out:  (event, ui) ->
      self = $(this)
      self.removeClass("hover")
      $scope.stopDragging ui.draggable[0], self
    drop: (event, ui) ->
      self = $(this)
      self.removeClass("hover")
      $scope.drop ui.draggable[0], self, ui
  }

  $("#half").change (e) ->
    selectedItem = $(this).children(":selected").val()
    window.location.pathname = "/games/#{$scope.gameId}/report/make/#{selectedItem}"

  $("#finalize").click (e) ->
    e.preventDefault()
    console.log(e)

  # init stuff

  $scope.gameId = $("#match-reporter").data "game-id"
  $scope.currentHalf = $("ul.positions").data "half"

  $.ajax "/games/#{$scope.gameId}", {
    success: (data, status, xhr) ->
      $scope.game = data
  }

  $.ajax "/games/#{$scope.gameId}/substitutions/#{$scope.currentHalf}", {
    dataType: "json",
    success: $scope.render
  }
