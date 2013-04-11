# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  unshade = (el) ->
    shade = $(el).parent().find(".shade")
    child = $(el).find("> *:first-child")
    offset = -1 * ($(el).height() - child.position().top - child.height())
    shade.css "opacity", Math.min(offset, 30) / 150

  $(".dashboard-item").on "scroll", (e) -> unshade e.target

  $(".dashboard-item").each (_ix,el) -> unshade el

$(document).on({
  mouseover: -> $(this).html "not coming",
  mouseout: -> $(this).html "coming"
}, ".game-attendance .button.green")

.on({
  mouseover: -> $(this).html "coming",
  mouseout: -> $(this).html "not coming"
}, ".game-attendance .button.red")

.on("click", ".game-attendance .button", ->
  $(this).parent().children('i').removeClass('hidden'))

.on("ajax:before", "#attendance-link.open", (e) ->
  $(this).removeClass("open").addClass("closed")
  $(".attendance").slideUp 300, -> $(this).html("")
  false)

.on("ajax:success", ".game-attendance .button", (evt, json, status, error) ->
  $(this).removeClass(if json.attending then "red" else "green")
    .addClass(if json.attending then "green" else "red")
    .html(if json.attending then "coming" else "not coming")
    .parent()
    .removeClass(if json.attending then "no" else "yes")
    .addClass(if json.attending then "yes" else "no")
    .children("i").addClass("hidden"))

.on("ajax:success", "#attendance-link.closed", (evt, json, status, error) ->
  $(".attendance").html(json.tmpl).slideDown(300)
  $("#attendance-link").removeClass("closed").addClass("open"))
