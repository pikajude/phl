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

  $scope.tryDrop = (event, ui) ->
    debugger

  angular.element("li.player").draggable({revert: true})
  angular.element("#match-reporter li").droppable {
    drop: $scope.tryDrop
  }

  $scope.substitution = (pos, side, idx) ->
    if $scope.subs
      subs = $scope.subs[side][pos][idx]
      ("""
        <div style='width: #{(sub.off_time - sub.on_time) / $scope.game.length * 100}%'>
          hi
        </div>
      """ for sub in subs).join ""
    else
      ""
