# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $("#new_project").submit (e) ->
    unless $("#project_url").val().match(/(\d{5,6})/)
      e.preventDefault()
      alert "Please enter a donors choose valid url"
