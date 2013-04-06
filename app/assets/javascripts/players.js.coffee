# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on {
    mouseover: -> $(this).html "not coming",
    mouseout: -> $(this).html "coming"
  }, ".game-attendance .button.green"
  $(document).on {
    mouseover: -> $(this).html "coming",
    mouseout: -> $(this).html "not coming"
  }, ".game-attendance .button.red"
  $(document).on "click", ".game-attendance .button", ->
    $(this).parent().children('i').removeClass('hidden')

  unshade = (el) ->
    shade = $(el).parent().find(".shade")
    child = $(el).find("> *:first-child")
    offset = -1 * ($(el).height() - child.position().top - child.height())
    shade.css "opacity", Math.min(offset, 30) / 150

  $(".dashboard-item").on "scroll", (e) -> unshade e.target

  $(".dashboard-item").each (_ix,el) -> unshade el

  $(document).on "ajax:before", "#attendance-link.open", (e) ->
    e.preventDefault()
    $(this).removeClass("open").addClass("closed")
    $(".attendance").slideUp 300, -> $(this).html("")
    false
