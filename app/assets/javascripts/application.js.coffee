# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery_ujs
#= require jquery.ui.effect.all
#= require jquery.ui.draggable
#= require jquery.ui.droppable
#= require jquery.ui.resizable
#= require turbolinks
#= require underscore
#= require angular
#= require jquery.tipsy
#= require angular-dragdrop
#= require angular-sanitize
#= require_tree .

$.ajaxSettings.dataType = "json"

$(document).ready ->
  $(".tooltip").tipsy {gravity: $.fn.tipsy.autoWE}

  $("#alert .close, #notice .close").on "click", ->
    $(this).parent().slideUp 400

    # $(document).on "ajax:error", (evt, xhr, status, error) ->
    #   debugger
    #   errs = $.parseJSON(xhr.responseText).errors
    #   $("<div id='error'>").append(
    #     $("<ul>").append(
    #       $.map errs, (err) ->
    #         $("<li>").text err)).prependTo($("#content"))
