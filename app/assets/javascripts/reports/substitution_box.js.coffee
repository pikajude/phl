$.SubstitutionBox = (id) ->
  self = this
  this.substitutions = {}
  $.ajax("/games/#{id}/substitutions", {
    success: (data, status, xhr) ->
      self.substitutions[sub.player_id] = sub for sub in data
  })
  this

$.SubstitutionBox.prototype = {
  addSubstitution: (id, startTime, replacedId) ->
    this.substitutions[id] = _.clone this.substitutions[replacedId]
    _.extend this.substitutions[id],
      {
        on_time: startTime
      }
    this.substitutions[replacedId].off_time = startTime
}
