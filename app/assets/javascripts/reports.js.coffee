# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

update_scores = ->
  $("span.home-score").text($(".goals .home").length)
  $("span.away-score").text($(".goals .away").length)

$(document)
.ready ->
  update_scores()
  $("li.player").draggable {
    revert: true,
    revertDuration: 0
  }
  $("li.position").droppable {
    accept: "li.player",
    hoverClass: "hovered",
    drop: (event, ui) ->
      $(this).html ui.draggable.text()
      $(this).addClass "hovered"
      $(".substitutions .position-#{$(this).data "position"}").css {
        background: "yellow"
      }
  }

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

# update form on change!
.on("blur", ".edit_goal input", ->
  $(this).parents("form").submit())

# update form on change redux!
.on("change", ".edit_goal select", ->
  $(this).parents("form").submit())

# re-render goals on change!
.on("ajax:success", "form.edit_goal", (evt, json, status, error) ->
  $(".goals").html(goal.tmpl for goal in json.goals)
  $("#goal-#{json.updated}").effect "highlight", {}, 1000
  $("span#score-#{json.team}").text("hi")
  update_scores())

.on("ajax:error", "form.edit_goal", (evt, xhr, status, error) ->
  json = $.parseJSON(xhr.responseText)
  $("#goal-#{json.id} .problem").removeClass "problem"
  $.each json.errors, (_,k) ->
    $("#goal-#{json.id}_goal_#{k}").addClass "problem"
  $("#goal-#{json.id} ul").html($("<li>").text(msg) for msg in json.messages)
  update_scores())
