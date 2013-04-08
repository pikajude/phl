# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document)
# add a goal!
.on("ajax:success", ".goal-form", (evt, json, status, error) ->
  $(".goals").html(goal.tmpl for goal in json)
  $("select[name=scorer_id]").each ->
    $(this).children(":first-child").prop 'selected', true
    $(this).change())

# delete a goal!
.on("ajax:success", ".delete-goal", (evt, json, status, error) ->
  $("#goal-#{json.goal.id}_edit_goal_#{json.goal.id}, #delete-goal-#{json.goal.id}").remove())

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
  $(this).parent("form").submit())

# update time on change!
.on("blur", "input.goal-time", ->
  $(this).parent("form").submit())

# re-render goals on change!
.on("ajax:success", "form.edit_goal", (evt, json, status, error) ->
  $(".goals").html(goal.tmpl for goal in json.goals)
  $("#goal-#{json.updated}_edit_goal_#{json.updated}").effect "highlight", {}, 1000)
