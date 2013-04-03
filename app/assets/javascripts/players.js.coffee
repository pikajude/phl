# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("body").on {
    mouseover: -> $(this).html "not coming",
    mouseout:  -> $(this).html "coming"
  }, ".game-attendance .button.green"
  $("body").on {
    mouseover: -> $(this).html "coming",
    mouseout:  -> $(this).html "not coming"
  }, ".game-attendance .button.red"
  $("body").on {
    click: -> $(this).parent().children('i').removeClass('hidden')
  }, ".game-attendance .button"
