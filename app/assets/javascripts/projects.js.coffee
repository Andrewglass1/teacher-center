# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->

  $('.popupsmall').click () ->
    url = $(this).attr('href')
    window.open(url,"TeacherCenter Task","height=350,width=650,menubar=false")
    return false

  $('.popuplarge').click () ->
    url = $(this).attr('href')
    window.open(url,"TeacherCenter Task","height=700,width=850,menubar=false")
    return false

  $('.doer').click (event) ->
    pt_id = event.target.id
    $.ajax "/api/v1/project_tasks/#{pt_id}",
      format: 'json',
      type: 'put',
      id: pt_id,
      success: ->
        $(event.currentTarget).attr('href', '#')
        $(event.currentTarget).attr('target', '')
        $(event.currentTarget).text('Task Completed!')
        $(event.currentTarget).unbind("click")


  $('.letter-gen').click () ->
    $('#letterModal').modal('hide')
    $('#mail-doer').attr('href', '#')
    $('#mail-doer').attr('target', '')
    $('#mail-doer').text('Task Completed!')





