# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

update_scores = ->
  $("span.home-score").text($(".goals .home").length)
  $("span.away-score").text($(".goals .away").length)

$(document)
# add a goal!
.on("ajax:success", ".goal-form", (evt, json, status, error) ->
  $(".goals").html(goal.tmpl for goal in json.goals)
  $("#goal-#{json.updated}").effect("highlight", {}, 1000)
  $("select[name=scorer_id]").each ->
    $(this).children(":first-child").prop 'selected', true
    $(this).change()
  update_scores())

# delete a goal!
.on("ajax:success", ".delete-goal", (evt, json, status, error) ->
  $(this).parent().remove()
  update_scores())

# make the link (un)clickable!
.on("change", "select[name=scorer_id]", ->
  player = $(this).children(":selected")[0].value
  link = $(this).parent().children "input[type=submit]"
  if(player == "")
    link.attr("disabled", "disabled")
      .attr("href", "#")
  else
    link.removeAttr("disabled")
      .attr "href", "/games/#{link.data("game-id")}/report/goal/#{player}")

# change scorers on submit!
.on("change", "select.scorer, select.first-assist", ->
  $(this).parents("form").submit())

# update time on change!
.on("blur", "input.goal-time", ->
  $(this).parents("form").submit())

# re-render goals on change!
.on("ajax:success", "form.edit_goal", (evt, json, status, error) ->
  $(".goals").html(goal.tmpl for goal in json.goals)
  $("#goal-#{json.updated}").effect "highlight", {}, 1000
  $("span#score-#{json.team}").text("hi")
  update_scores())

.on("ajax:error", "form.edit_goal", (evt, xhr, status, error) ->
  json = $.parseJSON(xhr.responseText)
  $.each json.errors, (_,k) ->
    $("#goal-#{json.id}_goal_#{k}").addClass "problem"
  $("#goal-#{json.id} ul").html($("<li>").text(msg) for msg in json.messages)
  update_scores())
