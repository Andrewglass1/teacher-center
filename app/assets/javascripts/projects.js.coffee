# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('.doer').click (event) ->
    pt_id = event.target.id
    $.ajax "/api/v1/project_tasks/#{pt_id}",
      format: 'json',
      type: 'put',
      id: pt_id,
      success: ->
        $(event.currentTarget).attr('href', '#')
        $(event.currentTarget).attr('target', '')
        $(event.currentTarget).text('Completed!')
