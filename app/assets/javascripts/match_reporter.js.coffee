window.MatchReporter = ($scope) ->
  $scope.game_id = angular.element("#match-reporter").data("game-id")

  $.ajax "/games/#{$scope.game_id}/substitutions", {
    success: (data, status, xhr) ->
      # $scope.subs = data
      $scope.$apply ->
  }

  $scope.tryDrop = ->
    debugger

  angular.element("li.player").draggable({revert: true})
  angular.element("#match-reporter li").droppable {
    drop: $scope.tryDrop
  }

  $scope.substitution = (pos, side, idx) ->
    if $scope.subs
      debugger
      subs = $scope.subs[side][pos][idx]
      angular.element("li##{pos}-#{side}-#{idx}").html(
        "#{sub.on_time} - #{sub.off_time}" for sub in subs)
    else
      ""
